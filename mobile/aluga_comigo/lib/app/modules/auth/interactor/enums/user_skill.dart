enum UserSkill {
  none,
  cucaMaster,
  ninjaInSweeping,
  humanDishwasher,
  laundryOperator,
}

UserSkill getUserSkill(String value) {
  for (var item in UserSkill.values) {
    if (item.name == value) {
      return item;
    }
  }
  return UserSkill.none;
}
