enum UserSkill {
  none,
  cucaMaster,
  ninjaInSweeping,
  humanDishwasher,
  laundryOperator;

  static UserSkill get(String value) {
    for (var item in UserSkill.values) {
      if (item.name == value) {
        return item;
      }
    }
    return UserSkill.none;
  }
}
