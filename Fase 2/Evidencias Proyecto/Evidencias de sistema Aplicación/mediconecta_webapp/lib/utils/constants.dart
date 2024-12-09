class Constants {
  // final baseURL = 'http://192.168.152.20:3000/api';
  final baseURL = 'https://mediconecta-server.onrender.com/api';

  final Map<String, List<int>> roleAccessArray = {
      'Administrador': [1, 2, 4, 5, 6, 7, 8],
      'Recepcionista': [0, 7, 8],
      'Doctor': [3, 7, 8],
  };
}