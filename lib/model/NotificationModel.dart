//
//  NotificationModel.dart
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 9, 2020

class NotificationModel {  
  String createdAt;    
  int isDeleted;    
  int isRead;    
  String message;    
  int notificationId;    
  int type;    
  String updatedAt;    
  int userId;    

  NotificationModel.fromJSON(Map<String, dynamic> parsedJson) {    
    this.createdAt = parsedJson['created_at'];    
    this.isDeleted = parsedJson['is_deleted'];    
    this.isRead = parsedJson['is_read'];    
    this.message = parsedJson['message'];    
    this.notificationId = parsedJson['notification_id'];    
    this.type = parsedJson['type'];    
    this.updatedAt = parsedJson['updated_at'];    
    this.userId = parsedJson['user_id'];    
  }
}