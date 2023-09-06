class Notes{
  int? id;
  String? title;
  String? description;
  String? dateTime;
  String? category;
  int? isStared;

  Notes({this.id,this.title,this.description,this.dateTime,this.category,this.isStared});

  factory Notes.fromJson(Map<String,dynamic> json)=>Notes(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    dateTime: json['dateTime'],
    category: json['category'],
      isStared: json['isStared']
  );

  Map<String,dynamic> toJson()=>{
    'id':id,
    'title':title,
    'description':description,
    'dateTime':dateTime,
    'category':category,
    'isStared':isStared,
  };
}