class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    image: "images/scren1.png",
    title: 'Select From Our \n      Best Menu',
    description: "Pick your food from our menu \n            More than 35 times ",//spacing
  ),
  UnboardingContent(
    image: "images/scre2.jpg",
    title: 'Easy and Online Payment',
    description: 'You can Pay cash on delivery\n  and Card payment is available',
  ),
  UnboardingContent(
    image: "images/scre3.jpg",
    title: '  Quick Delivery App at Your  \n                   Doorsteps',
    description: 'Deliver Your Food at Your\n            Doorsteps',
  ),
];
