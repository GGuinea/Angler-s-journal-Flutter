class GetFishes {
   int id;  
   String name;
   String type;
   String img;
   String desc;

   GetFishes({
       this.id,
       this.name,
       this.type,
       this.img,
       this.desc
   });

   factory GetFishes.fromJson(Map<String, dynamic> json) {
        return GetFishes(
            id: json['id'],
            name: json['name'],
            type: json['type'],
            img: json['img'],
            desc: json['desc']
        );
    }
}
