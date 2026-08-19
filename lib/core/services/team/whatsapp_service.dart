import 'package:url_launcher/url_launcher.dart';
import 'package:projetmascara/core/services/logger_service.dart';

class WhatsAppService {
  static Future<void> openWhatsApp(String phoneNumber) async {
    // 1. Clean the number
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    
    // 2. Convert Algerian numbers to international format if needed
    if (cleanedNumber.startsWith('0')) {
      cleanedNumber = '+213${cleanedNumber.substring(1)}';
    } else if (!cleanedNumber.startsWith('+')) {
      // Assuming it's already an international number without + or local number starting with 5/6/7
      if (cleanedNumber.startsWith('5') || cleanedNumber.startsWith('6') || cleanedNumber.startsWith('7')) {
         cleanedNumber = '+213$cleanedNumber';
      }
    }

    // 3. Build WhatsApp URL
    // Use https://wa.me/ for universal compatibility
    final Uri whatsappUri = Uri.parse("https://wa.me/${cleanedNumber.replaceAll('+', '')}");
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        logger.e('Could not launch WhatsApp for $cleanedNumber');
        throw 'WHATSAPP_NOT_INSTALLED';
      }
    } catch (e) {
      logger.e('Error opening WhatsApp: $e');
      rethrow;
    }
  }
}
