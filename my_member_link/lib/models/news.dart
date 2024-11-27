class News {
  String? newsId;
  String? newsTitle;
  String? newsDetails;
  String? newsDate;
  int? newsLikes;
  int? newsSaves;

  News({
    this.newsId, 
    this.newsTitle, 
    this.newsDetails, 
    this.newsDate, 
    this.newsLikes=0,  
    this.newsSaves=0,
    });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['news_id'],
      newsTitle: json['news_title'],
      newsDetails: json['news_details'],
      newsDate: json['news_date'],
      newsLikes: int.tryParse(json['news_likes']?.toString() ?? '0') ?? 0,
      newsSaves: int.tryParse(json['news_saves']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson (){
    final Map<String,dynamic> data = <String, dynamic>{};
    data['news_id'] = newsId;
    data['news_title'] = newsTitle;
    data['news_details'] = newsDetails;
    data['news_date'] = newsDate;
    data['news_likes'] = newsLikes;
    data['news_saves'] = newsSaves;
    return data;
  }
}