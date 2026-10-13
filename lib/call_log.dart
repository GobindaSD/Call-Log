enum CallType { outgoing, incoming, missed }

class CallLog {
  final String name;
  final String country;
  final String time;
  final CallType type;
  final String section;
  final int sim; // 1 ba 2

  const CallLog({
    required this.name,
    required this.country,
    required this.time,
    required this.type,
    required this.section,
    required this.sim,
  });
}

const List<String> tabBars = ['All', 'Missed', 'Contacts', 'Non-Spam', 'Spam'];

const List<CallLog> callLogs = [
  CallLog(name: 'Samim Sir', country: 'Bangladesh', time: '3:00 pm', type: CallType.outgoing, section: 'Today', sim: 1),
  CallLog(name: 'Ratul', country: 'Bangladesh', time: '2:12 pm', type: CallType.incoming, section: 'Today', sim: 1),
  CallLog(name: 'Tarif', country: 'Bangladesh', time: '1:10 pm', type: CallType.incoming, section: 'Today', sim: 1),
  CallLog(name: 'Raihan', country: 'Bangladesh', time: '12:49 pm', type: CallType.outgoing, section: 'Today', sim: 2),
  CallLog(name: 'Jonahid', country: 'Bangladesh', time: '11:52 am', type: CallType.missed, section: 'Yesterday', sim: 1),
  CallLog(name: 'Mehedi Hasan', country: 'Bangladesh', time: '12:30 pm', type: CallType.missed, section: 'Yesterday', sim: 2),
  CallLog(name: 'Jahid', country: 'Bangladesh', time: '8:00 pm', type: CallType.incoming, section: 'Yesterday', sim: 2),
];