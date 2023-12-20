import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _db;
  
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    databaseFactory = databaseFactoryFfiWeb; // necessario pq uso chrome
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "data.db");
    
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        String sql = """
           CREATE TABLE user(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
                email VARCHAR NOT NULL UNIQUE,
                password VARCHAR NOT NULL
            );

            INSERT INTO user(name, email, password) VALUES('Teste 1', 'teste1@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 2', 'teste2@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 3', 'teste3@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 4', 'teste4@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 5', 'teste5@teste', '123456');

            CREATE TABLE task_board(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
              color INTEGER NOT NULL
            );

            INSERT INTO task_board(name, color) VALUES('Trabalho', 1);
            INSERT INTO task_board(name, color) VALUES('Saúde', 2);
            INSERT INTO task_board(name, color) VALUES('Estudo', 3);
            INSERT INTO task_board(name, color) VALUES('Flutter', 4);
            INSERT INTO task_board(name, color) VALUES('Academia', 5);

            CREATE TABLE task(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              board_id INTEGER NOT NULL,
                title VARCHAR NOT NULL,
                note TEXT NOT NULL,
                date VARCHAR NOT NULL,
                startTime VARCHAR NOT NULL,
              endTime VARCHAR NOT NULL,
              isCompleted INTEGER,
              FOREIGN KEY(user_id) REFERENCES user(id),
              FOREIGN KEY(board_id) REFERENCES task_board(id)
            );

            INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(1, 1, 'Criar Projeto', 'Definir a estrutura do projeto indicando a linguagem de programação e dados necessários.', '2023-12-01', '2024-01-01', '2024-01-02', 0);
            INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(1, 2, 'Comprar Frutas', 'Comprar maça, banana e abacaxi.', '2023-12-01', '2024-01-01', '2024-01-02', 0);
            INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(2, 3, 'Estudar P2 de Sistemas Operacionais', 'Fazer resumo de Gerência de Memória focando em Paginação.', '2023-12-01', '2024-01-01', '2024-01-02', 0);
            INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(3, 4, 'Projeto Planner de Tarefas', 'Organizar tarefas com o grupo e definir a estrutura do projeto.', '2023-12-01', '2023-12-01', '2022-12-20', 0);
            INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(3, 5, 'Correr no Campus da UFF', 'Alcançar a meta de 5KM.', '2023-12-01', '2024-01-01', '2024-01-02', 0);


            select task.id, task.title, task.note, task_board.name, user.name from task left join task_board on task.board_id = task_board.id left join user on user.id = task.user_id;

            select title, note, date, strftime('%d', date) as "Day" from task where strftime('%m', date) = '12';


            """;
         await db.execute(sql);

      }
    );

    return db;
  }


}