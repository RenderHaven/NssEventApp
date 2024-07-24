import '../../DataManagment/ApiService.dart';

class Accept {
  Future<bool> accept({required String UserId,required String EvtId,required bool IsOk}) async {
    try {
      final _data = {
        'UserId': UserId,
        'EventId': EvtId,
        'IsOk': IsOk,
      };
      if(IsOk==true) {
        await ApiService().uploadImage(data: _data);
        return true;
      }
      else{
        final ans=await ApiService().deleteMyEventList(UserId: UserId, EventId: EvtId);
        return ans;
      }
    } catch (e) {
      return false;
      print('Error uploading image: $e');
    }
  }
}