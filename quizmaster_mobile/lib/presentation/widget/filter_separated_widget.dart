// import 'package:flutter/material.dart';

// class FilterSeparatedWidget extends StatelessWidget {
//   const FilterSeparatedWidget({super.key, required this.listFilter, required this.onTap});
//   final List<String>  listFilter;
//   final VoidCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//                 height: 50,
//                 child: ListView.separated(
//                   scrollDirection: .horizontal,
//                   shrinkWrap: true,
//                   itemCount: listFilter.length,
//                   separatorBuilder: (BuildContext context, int index) =>
//                       SizedBox(width: 12),

//                   itemBuilder: (context, index) {
//                     final catalogue = listFilter[index];
//                     return InkWell(
//                       onTap: () => onTap!(catalogue, ""),
//                       child: Chip(
//                         label: Text(
//                           catalogue,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         backgroundColor: selected.value == catalogue
//                             ? theme.colorScheme.primary
//                             : theme.colorScheme.secondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),;
//   }
// }
