import 'package:flutter/material.dart';
import 'package:instagram/screens/screens.dart';
import 'package:instagram/screens/search/cubit/search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/widgets/user_profile_image.dart';
import 'package:instagram/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                border: InputBorder.none,
                filled: true,
                hintText: 'Search User',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    context.read<SearchCubit>().clearSearch();
                    _textEditingController.clear();
                  },
                ),
              ),
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<SearchCubit>().searchUser(query: value.trim());
                }
              }),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(text: state.failure.message);
              case SearchStatus.loading:
                return Center(
                    child: CircularProgressIndicator(color: Colors.purple));
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              radius: 20.0,
                              profileImageUrl: user.profileImageUrl,
                            ),
                            title: Text(user.username,
                                style: TextStyle(fontSize: 16.0)),
                            onTap: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: ProfileScreenArgs(userId: user.id)),
                          );
                        })
                    : CenteredText(text: 'No user found');
              default:
                return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
