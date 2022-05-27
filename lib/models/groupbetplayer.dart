class GroupBetPlayers {
  int id = 0;
  bool isAccepted = true;
  bool isBlocked = false;

  GroupBetPlayers(
      {required this.id, required this.isAccepted, required this.isBlocked});

  GroupBetPlayers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAccepted = json['isAccepted'];
    isBlocked = json['isBlocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isAccepted'] = this.isAccepted;
    data['isBlocked'] = this.isBlocked;
    return data;
  }
}
