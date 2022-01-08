class Images {
  static const String AppBar = "assets/images/appbar.png";
  static const String Logo = "assets/images/logo.png";
  static const String LogoTransparent = "assets/images/logo_transparent.png";

  //** tabs */
  static const String Home = "assets/images/tabs/home.png";
  static const String HomeActive = "assets/images/tabs/home_active.png";
  static const String Categories = "assets/images/tabs/categories.png";
  static const String CategoriesActive =
      "assets/images/tabs/categories_active.png";
  static const String CartTab = "assets/images/tabs/cart.png";
  static const String CartTabActive = "assets/images/tabs/cart_active.png";
  static const String ProfileTab = "assets/images/tabs/profile.png";
  static const String ProfileTabActive =
      "assets/images/tabs/profile_active.png";
  static const String OrdersTab = "assets/images/tabs/orders.png";
  static const String OrdersTabActive = "assets/images/tabs/orders_active.png";

  static const String OrdersMenu = "assets/images/tabs/orders_menu.png";
  static const String Truck = "assets/images/tabs/truck.png";
  static const String SearchIcon = "assets/images/tabs/search.png";
  static const String MenuIcon = "assets/images/tabs/menu.png";
  static const String DeleteIcon = "assets/images/tabs/delete.png";

  static const String EditAddress = "assets/images/tabs/edit_address.png";
  static const String DeleteAddress = "assets/images/tabs/delete_address.png";
  static const String Check = "assets/images/tabs/check.png";
  static const String DropPin = "assets/images/tabs/drop_pin.png";
  static const String Visa = "assets/images/tabs/visa.png";
  static const String Cash = "assets/images/tabs/cash.png";

  //** Home */
  static const String SliderImage = "assets/images/home/slider.png";
  static const String Search = "assets/images/home/search.png";
  static const String ProductImage = "assets/images/home/item_1.png";
  static const String AddedToCart = "assets/images/home/cart.png";

  //** Account */
  static const String WhatsappIcon = "assets/images/account/whatsapp.png";
  static const String InstagramIcon = "assets/images/account/instagram.png";
  static const String TwitterIcon = "assets/images/account/twitter.png";
  static const String SnapchatIcon = "assets/images/account/snapchat.png";
  static const String MobileIcon = "assets/images/account/mobile.png";
  static const String AccountIcon = "assets/images/account/account.png";
  static const String MoneyIcon = "assets/images/account/money.png";
  static const String TelegramIcon = "assets/images/account/telegram.png";
  static const String StarIcon = "assets/images/account/star.png";
  static const String Saudi = "assets/images/account/saudi.png";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
