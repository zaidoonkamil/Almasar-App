import '../ navigation/navigation.dart';
import '../../features/auth/view/login.dart';
import '../network/local/cache_helper.dart';

String token='';
String id='';
String adminOrUser='' ;
String callPhone='7744486170';
String whatsAppPhone='7748052440';
String howWeAre='نهدف إلى تقديم خدمات توصيل سريعة وموثوقة تعزز راحة العملاء وثقتهم' ;

void signOut(context)
{
  CacheHelper.removeData(
    key: 'token',
  ).then((value)
  {
    token='';
    adminOrUser='' ;
    id='' ;
    if (value)
    {
      CacheHelper.removeData(key: 'role',);
      CacheHelper.removeData(key: 'id',);
      navigateTo(context, const Login(),);
    }
  });
}
