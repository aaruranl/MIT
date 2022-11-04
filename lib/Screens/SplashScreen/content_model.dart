class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: '',
      image: 'assets/png/onboarding 1.png',
      discription: "Explore your favourite destination with us around the world"),
  UnbordingContent(
      title: '',
      image: 'assets/png/onboarding 2.png',
      discription:
          "Select a destination and start schedulimg details for your trip"),
  UnbordingContent(
      title: '',
      image: 'assets/png/onboarding 3.png',
      discription:
          "Enjoy the beautiful memories and relax your heart"),
];
