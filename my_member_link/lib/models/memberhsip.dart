class Membership {
  String? membershipId;
  String? membershipName;
  String? membershipDescription;
  String? membershipPrice;
  String? membershipBenefits;
  String? membershipDuration;
  String? membershipTerms;
  String? membershipFilename;
  String? membershipDateCreated;
  String? membershipStatus;

  Membership({
    this.membershipId,
    this.membershipName,
    this.membershipDescription,
    this.membershipPrice,
    this.membershipBenefits,
    this.membershipDuration,
    this.membershipTerms,
    this.membershipFilename,
    this.membershipDateCreated,
    this.membershipStatus,
  });

  // Factory method to create an object from JSON
  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      membershipId: json['membership_id'],
      membershipName: json['membership_name'],
      membershipDescription: json['membership_description'],
      membershipPrice: json['membership_price'],
      membershipBenefits: json['membership_benefits'],
      membershipDuration: json['membership_duration'],
      membershipTerms: json['membership_terms'],
      membershipFilename: json['membership_filename'],
      membershipDateCreated: json['membership_dateCreated'],
      membershipStatus: json['membership_status'],
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['membership_name'] = membershipName;
    data['membership_description'] = membershipDescription;
    data['membership_price'] = membershipPrice;
    data['membership_benefits'] = membershipBenefits;
    data['membership_duration'] = membershipDuration;
    data['membership_terms'] = membershipTerms;
    data['membership_filename'] = membershipFilename;
    data['membership_dateCreated'] = membershipDateCreated;
    data['membership_status'] = membershipStatus;
    return data;
  }
}
