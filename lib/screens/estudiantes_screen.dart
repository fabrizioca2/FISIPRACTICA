import 'package:flutter/material.dart';
import 'package:flutter_app/services/estudiantes_services.dart';
import 'dart:typed_data';

import '../widgets/footer.dart';
import '../widgets/header.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  _EstudiantesScreenState createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  List<Map<String, dynamic>> estudiantes = [];
  void _fetchEstudiantes() async {
    try {
      List<Map<String, dynamic>> fetchedEstudiantes =
          await EstudiantesServices.getEstudiantes();
      setState(() {
        estudiantes = fetchedEstudiantes;
      });
    } catch (e) {
      // Handle error
      print('Error fetching estudiantes: $e');
    }
  }
/* 
  @override
  void initState() {
    super.initState();
    _fetchEstudiantes();
  } */

  /*  {
      'nombre': 'Juan Pérez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Juan Pérez'
    },
    {
      'nombre': 'María López',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de María López'
    },
    {
      'nombre': 'Carlos García',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Carlos García'
    },
    {
      'nombre': 'Ana Martínez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Ana Martínez'
    },
    {
      'nombre': 'Luis Rodríguez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Luis Rodríguez'
    },
    {
      'nombre': 'Sofía Hernández',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Sofía Hernández'
    },
    {
      'nombre': 'Miguel Torres',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Miguel Torres'
    },
    {
      'nombre': 'Laura Gómez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Laura Gómez'
    },
    {
      'nombre': 'Pedro Díaz',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Pedro Díaz'
    },
    {
      'nombre': 'Lucía Fernández',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Lucía Fernández'
    },
  ]; */

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _fetchEstudiantes();
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage * _itemsPerPage < estudiantes.length) {
        _currentPage++;
      }
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  List<Widget> _buildPageNumbers(int totalPages) {
    List<Widget> pageNumbers = [];

    pageNumbers.add(_buildPageNumberButton(1));

    if (_currentPage > 3) {
      pageNumbers.add(Text('...'));
    }

    if (_currentPage > 1 && _currentPage < totalPages) {
      pageNumbers.add(_buildPageNumberButton(_currentPage));
    }

    if (_currentPage < totalPages - 2) {
      pageNumbers.add(Text('...'));
    }

    if (totalPages > 1) {
      pageNumbers.add(_buildPageNumberButton(totalPages));
    }

    return pageNumbers;
  }

  Widget _buildPageNumberButton(int page) {
    return TextButton(
      onPressed: () => _goToPage(page),
      child: Text(
        '$page',
        style: TextStyle(
          fontWeight:
              _currentPage == page ? FontWeight.bold : FontWeight.normal,
          color: _currentPage == page ? Color(0xFF1E3984) : Colors.black,
        ),
      ),
    );
  }

  void _showStudentDialog(Map<String, dynamic> estudiante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: estudiante['foto'] is Uint8List
                    ? MemoryImage(estudiante['foto'] as Uint8List)
                    : estudiante['foto'] is String
                        ? AssetImage(estudiante['foto'] as String)
                        : null,
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                estudiante['nombre']!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(estudiante['descripcion']!),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: Text('Mantener'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Eliminar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showConfirmationDialog(estudiante);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(Map<String, dynamic> estudiante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content:
              Text('¿Seguro de que deseas eliminar a ${estudiante['nombre']}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    List<Map<String, dynamic>> currentEstudiantes = estudiantes.sublist(
      startIndex,
      endIndex > estudiantes.length ? estudiantes.length : endIndex,
    );

    int totalPages = (estudiantes.length / _itemsPerPage).ceil();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Header(), // Header en la parte superior de la pantalla
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Estudiantes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3984),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: currentEstudiantes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color(0xFFDBE2F6),
                  elevation: 5,
                  child: InkWell(
                    onTap: () => _showStudentDialog(currentEstudiantes[index]),
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: currentEstudiantes[index]['foto']
                                      is Uint8List
                                  ? MemoryImage(currentEstudiantes[index]
                                      ['foto'] as Uint8List)
                                  : currentEstudiantes[index]['foto'] is String
                                      ? AssetImage(currentEstudiantes[index]
                                          ['foto'] as String)
                                      : null),
                          title: Text(
                            currentEstudiantes[index]['nombre']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1E3984),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousPage,
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: _buildPageNumbers(totalPages),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextPage,
              ),
            ],
          ),
          Footer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
