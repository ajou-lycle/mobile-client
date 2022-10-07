enum PageRoutes {
  loading('/'),
  login('/login'),
  signUpAccountNameAndPassword('/sign-up/account_name_and_password'),
  signUpInfo('/sign-up/info'),
  home('/home'),
  nftCardList('/home/nft_card_list'),
  nftDetail('/home/fnt_card_list/nft_detail'),
  questList('/home/quest_list'),
  questDetail('/home/quest_list/quest_detail');

  final String routeName;

  const PageRoutes(this.routeName);
}