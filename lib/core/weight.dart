class Weight {
  final int amountInGrams;

  double inKg() {
    return this.amountInGrams / 1000;
  }

  double inTon() {
    return this.amountInGrams / 1000000;
  }

  Weight(this.amountInGrams);

  Weight operator +(Weight other) {
    return Weight(this.amountInGrams + other.amountInGrams);
  }
}
