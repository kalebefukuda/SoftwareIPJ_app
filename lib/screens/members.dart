import 'package:flutter/material.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final List<String> members = [
    'Kalebe Fukuda de Oliveira',
    'João Silva',
    'Maria Souza',
    'Ana Pereira',
    'Pedro Santos'
  ];

  final List<String> phoneNumbers = [
    '66 999755645',
    '66 999756546',
    '66 999123456',
    '66 999987654',
    '66 999765432'
  ];

  final List<String> avatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Altere a cor conforme seu tema
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Membros', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contagem de membros
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('120 Homens', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 20),
                Text('80 Mulheres', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 16),
            // Barra de pesquisa
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: const TextStyle(fontSize: 16, color: Color(0xFFB5B5B5), fontWeight:FontWeight.w400),
                filled: true,
                fillColor: const Color(0xFFE7E7E7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFFB5B5B5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de membros
            Text('Todos os membros:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(avatars[index]),
                    ),
                    // nomes membros  
                    title: Text(
                      members[index],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15),
                      
                    ),
                    // numero telefone
                    subtitle: Text(
                      phoneNumbers[index],
                      style: const TextStyle(
                        color: Color(0xFFB5B5B5), // Cor personalizada para o número de telefone
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
