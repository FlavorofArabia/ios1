import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/blocs.dart';
import '../../blocs/categories/categories_bloc.dart';
import '../../config/images.dart';
import '../../screens/category/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Widget spacer() => SizedBox(height: 10);

  Widget _item({icon, title, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            icon != null
                ? Row(
                    children: [
                      Icon(
                        Icons.arrow_right,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 15),
                    ],
                  )
                : Container(),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
                // Translate.of(context).translate('profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 3,
                child: Center(
                  child: Container(
                    width: 140.0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Images.Logo),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      BlocBuilder<CategoriesBloc, CategoriesState>(
                        builder: (context, state) {
                          if (state is GettingCategoriesDone) {
                            return Column(
                              children: List.generate(
                                state.categories.length,
                                (index) => _item(
                                  title: state.categories[index].name,
                                  onTap: () => Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          CategoryScreen(
                                        categoryId: state.categories[index].id,
                                        categoryName:
                                            state.categories[index].name,
                                        filters:
                                            state.categories[index].filters?[
                                                        'filter_groups'] !=
                                                    null
                                                ? state.categories[index]
                                                    .filters!['filter_groups']
                                                : [],
                                      ),
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                      transitionsBuilder: (_,
                                          Animation<double> animation,
                                          __,
                                          Widget child) {
                                        return Opacity(
                                          opacity: animation.value,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (state is GettingCategories) {
                            return Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          if (authState is Authenticated) {
                            return _item(
                              title: 'Logout',
                              onTap: () => BlocProvider.of<AuthBloc>(context)
                                  .add(Logout()),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
