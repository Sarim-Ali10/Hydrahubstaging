class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Analyze Your Skin Instantly",
    image: "images/5101822.jpg",
    desc: "Get a personalized skin analysis using advanced AI face scanning.",
  ),
  OnboardingContents(
    title: "Stay Connected With Expert Doctors",
    image: "images/3573471.jpg",
    desc:
    "Receive skin care recommendations from certified dermatologists.",
  ),
  OnboardingContents(
    title: "Personalized Product Picks",
    image: "images/9212299.jpg",
    desc:
    " Discover the best products tailored to your unique skin type..",
  ),
];