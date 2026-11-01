// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ليتزدتش';

  @override
  String get tabDiscover => 'اكتشف';

  @override
  String get tabEvents => 'الفعاليات';

  @override
  String get tabWallet => 'المحفظة';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get searchHint => 'ابحث عن مطاعم ومقاهٍ ونوادٍ';

  @override
  String get openNow => 'مفتوح الآن';

  @override
  String get closed => 'مغلق';

  @override
  String waitMinutes(int minutes) {
    return 'انتظار $minutes دقيقة';
  }

  @override
  String get valet => 'صف السيارات';

  @override
  String get happyHour => 'ساعة السعادة';

  @override
  String get todaysSpecials => 'أطباق اليوم';

  @override
  String get menu => 'القائمة';

  @override
  String get add => 'أضف';

  @override
  String get startTable => 'ابدأ طاولة';

  @override
  String get yourTable => 'طاولتك';

  @override
  String tableLabel(String label) {
    return 'طاولة $label';
  }

  @override
  String readyIn(int minutes) {
    return 'جاهز خلال $minutes دقيقة تقريبًا';
  }

  @override
  String get emptyOrder => 'لم تطلب شيئًا بعد. أضف أطباقًا من القائمة.';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get vat => 'ضريبة القيمة المضافة (5%)';

  @override
  String get tip => 'إكرامية';

  @override
  String get total => 'الإجمالي';

  @override
  String get splitBill => 'قسّم الفاتورة';

  @override
  String get splitEven => 'بالتساوي';

  @override
  String get splitByItem => 'حسب الطلب';

  @override
  String get splitCustom => 'مخصص';

  @override
  String get sharedWith => 'مشترك بين';

  @override
  String get everyone => 'الجميع';

  @override
  String get owes => 'عليه';

  @override
  String get payMyShare => 'ادفع حصتي';

  @override
  String get upcoming => 'القادمة';

  @override
  String get past => 'السابقة';

  @override
  String get createEvent => 'أنشئ فعالية';

  @override
  String get eventTitle => 'اسم الفعالية';

  @override
  String get budget => 'الميزانية';

  @override
  String perGuest(String amount) {
    return '$amount لكل ضيف';
  }

  @override
  String guestsGoing(int count) {
    return '$count مشارك';
  }

  @override
  String get save => 'حفظ';

  @override
  String get youOwe => 'عليك';

  @override
  String get owedToYou => 'لك';

  @override
  String get monthlySavings => 'وفّرت هذا الشهر';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get language => 'اللغة';

  @override
  String get membership => 'العضوية';

  @override
  String get demoMode => 'بيانات تجريبية: اربط Supabase للتشغيل الفعلي';

  @override
  String get signInTitle => 'مرحبًا بك في ليتزدتش';

  @override
  String get signInSubtitle => 'أدخل رقم هاتفك المحمول وسنرسل لك رمزًا.';

  @override
  String get phoneNumber => 'رقم الهاتف المحمول';

  @override
  String get sendCode => 'أرسل الرمز';

  @override
  String enterCode(String phone) {
    return 'أدخل الرمز المكوّن من 6 أرقام المرسل إلى $phone';
  }

  @override
  String get verify => 'تحقق';

  @override
  String get changeNumber => 'غيّر الرقم';

  @override
  String get invalidPhone => 'أدخل رقم هاتف إماراتي صحيحًا';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get guest => 'ضيف';
}
