class Pokemon {
  final String name;
  bool fav;

  setFav() {
    if (fav = true) {
      this.fav = false;
    } else {
      this.fav = true;
    }
  }

  Pokemon(this.name, this.fav);
}
