import '../../features/resources/professional_model.dart';

final List<Professional> mockProfessionals = [
  Professional(
    id: 'p1',
    name: 'Dr. Amine Rahmani',
    type: ProfessionalType.psychologist,
    specialty: 'Psychologue Clinicien',
    wilayaId: 'w16', // Alger
    phone: '021 00 00 00',
    isVerified: true,
  ),
  Professional(
    id: 'p2',
    name: 'Mme. Sarah Bensalem',
    type: ProfessionalType.counselor,
    specialty: 'Thérapeute TCC',
    wilayaId: 'w31', // Oran
    phone: '041 00 00 00',
    isVerified: true,
  ),
  Professional(
    id: 'p3',
    name: 'Dr. Karim Zidani',
    type: ProfessionalType.doctor,
    specialty: 'Psychiatre',
    wilayaId: 'w25', // Constantine
    phone: '031 00 00 00',
    isVerified: true,
  ),
  Professional(
    id: 'p4',
    name: 'Mme. Nadia Lamine',
    type: ProfessionalType.psychologist,
    specialty: 'Psychologie de l\'enfant',
    wilayaId: 'w16', // Alger
    phone: '021 11 11 11',
    isVerified: true,
  ),
  Professional(
    id: 'p5',
    name: 'Mr. Yassine Touati',
    type: ProfessionalType.socialWorker,
    specialty: 'Accompagnement Social',
    wilayaId: 'w6', // Béjaïa
    phone: '034 00 00 00',
    isVerified: true,
  ),
  Professional(
    id: 'p6',
    name: 'Dr. Selma Khelifi',
    type: ProfessionalType.neurologist,
    specialty: 'Neurologie',
    wilayaId: 'w19', // Sétif
    phone: '036 00 00 00',
    isVerified: true,
  ),
];
