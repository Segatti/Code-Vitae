import { createClient } from "npm:@supabase/supabase-js@2.49.1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-push-webhook-secret",
};

type ServiceAccount = {
  project_id: string;
  client_email: string;
  private_key: string;
};

type PushPayload = {
  account_id: string;
  title: string;
  body: string;
  reference_id?: string | null;
};

function base64UrlEncode(data: Uint8Array): string {
  const str = btoa(String.fromCharCode(...data));
  return str.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const lines = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s/g, "");
  const binary = atob(lines);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes.buffer;
}

async function importPrivateKey(pem: string): Promise<CryptoKey> {
  return crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(pem),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
}

async function createGoogleAccessToken(
  serviceAccount: ServiceAccount,
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const claim = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const enc = new TextEncoder();
  const unsigned = `${base64UrlEncode(enc.encode(JSON.stringify(header)))}.${base64UrlEncode(enc.encode(JSON.stringify(claim)))}`;
  const key = await importPrivateKey(serviceAccount.private_key);
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    enc.encode(unsigned),
  );
  const jwt = `${unsigned}.${base64UrlEncode(new Uint8Array(signature))}`;

  const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!tokenRes.ok) {
    const text = await tokenRes.text();
    throw new Error(`OAuth token failed: ${text}`);
  }

  const tokenJson = await tokenRes.json();
  return tokenJson.access_token as string;
}

async function sendFcm(
  accessToken: string,
  projectId: string,
  token: string,
  payload: PushPayload,
): Promise<Response> {
  const chatId = payload.reference_id?.toString() ?? "";
  const body = {
    message: {
      token,
      notification: {
        title: payload.title || "Nova mensagem",
        body: payload.body || "Você recebeu uma mensagem no chat",
      },
      data: {
        type: "chatMessage",
        chatId,
      },
      android: {
        priority: "HIGH",
        notification: {
          channel_id: "chat_messages",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    },
  };

  return fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    },
  );
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const webhookSecret = Deno.env.get("PUSH_WEBHOOK_SECRET");
    const incomingSecret = req.headers.get("x-push-webhook-secret");
    if (!webhookSecret || incomingSecret !== webhookSecret) {
      return new Response(JSON.stringify({ error: "unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const serviceAccountRaw = Deno.env.get("FIREBASE_SERVICE_ACCOUNT");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!serviceAccountRaw || !supabaseUrl || !serviceRoleKey) {
      return new Response(JSON.stringify({ error: "misconfigured" }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const payload = (await req.json()) as PushPayload;
    if (!payload.account_id) {
      return new Response(JSON.stringify({ error: "account_id required" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const serviceAccount = JSON.parse(serviceAccountRaw) as ServiceAccount;
    const accessToken = await createGoogleAccessToken(serviceAccount);

    const supabase = createClient(supabaseUrl, serviceRoleKey);
    const { data: tokens, error } = await supabase
      .from("device_push_tokens")
      .select("fcm_token")
      .eq("account_id", payload.account_id);

    if (error) {
      throw error;
    }

    if (!tokens?.length) {
      return new Response(JSON.stringify({ sent: 0, reason: "no_tokens" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    let sent = 0;
    const stale: string[] = [];

    for (const row of tokens) {
      const fcmToken = row.fcm_token as string;
      const res = await sendFcm(
        accessToken,
        serviceAccount.project_id,
        fcmToken,
        payload,
      );
      if (res.ok) {
        sent += 1;
        continue;
      }
      const errText = await res.text();
      if (
        errText.includes("UNREGISTERED") ||
        errText.includes("NOT_FOUND") ||
        errText.includes("InvalidRegistration")
      ) {
        stale.push(fcmToken);
      }
      console.error("FCM error", fcmToken, errText);
    }

    if (stale.length > 0) {
      await supabase
        .from("device_push_tokens")
        .delete()
        .eq("account_id", payload.account_id)
        .in("fcm_token", stale);
    }

    return new Response(JSON.stringify({ sent, stale: stale.length }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error(error);
    return new Response(JSON.stringify({ error: String(error) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
