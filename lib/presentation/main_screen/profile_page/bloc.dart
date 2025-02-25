import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc() : super(ProfilePageState()) {

  }
}
