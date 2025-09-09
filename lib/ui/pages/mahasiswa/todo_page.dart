import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/list_todo.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Tugas',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        children: const [
          ListTodo(
            title: 'Pemodelan dan Simulasi Komputer',
            kategori: 'Final Quiz',
            ruangan: '7D',
            time: 'Rabu, 18:30 - 20:00',
            status: 'Sudah dinilai',
            date: '22th, Mar 2024',
          ),
          ListTodo(
            title: 'Kalkulus',
            kategori: 'Semester Exam',
            ruangan: '2E',
            time: 'Kamis, 18:30 - 20:00',
            status: 'Dikirim',
            date: '23th, Mar 2024',
          ),
          ListTodo(
            title: 'Algoritma',
            kategori: 'Exam',
            ruangan: '2E',
            time: 'Jumat, 18:30 - 20:00',
            status: 'Tidak dikerjakan',
            date: '24th, Mar 2024',
          ),
          ListTodo(
            title: 'Front End Developer',
            kategori: 'Quiz',
            ruangan: '7D',
            time: 'Rabu, 18:30 - 20:00',
            status: 'Sudah dinilai',
            date: '25th, Mar 2024',
          ),
          ListTodo(
            title: 'Backend Developer',
            kategori: 'Semester Exam',
            ruangan: '2E',
            time: 'Kamis, 18:30 - 20:00',
            status: 'Dikirim',
            date: '26th, Mar 2024',
          ),
          ListTodo(
            title: 'Database',
            kategori: 'Exam',
            ruangan: '2E',
            time: 'Jumat, 18:30 - 20:00',
            status: 'Tidak dikerjakan',
            date: '27th, Mar 2024',
          )
        ],
      ),
    );
  }
}
