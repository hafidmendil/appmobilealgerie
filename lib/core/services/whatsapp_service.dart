import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  /// Opens WhatsApp with the given phone number.
  /// Converts Algerian local format (0XXXXXXXX) to international (+213XXXXXXXX).
  Future<void> openWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber.trim().replaceAll(' ', '');

    // Convert 06 to +2136, 05 to +2135, 07 to +2137
    if (formattedNumber.startsWith('0')) {
      formattedNumber = '+213${formattedNumber.substring(1)}';
    } else if (!formattedNumber.startsWith('+')) {
      // Assume it's already without leading 0 but missing +213
      formattedNumber = '+213$formattedNumber';
    }

    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp for $formattedNumber';
    }
  }
}
