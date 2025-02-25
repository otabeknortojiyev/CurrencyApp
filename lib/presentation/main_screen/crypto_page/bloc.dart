import 'package:bloc/bloc.dart';
import 'package:currency_app/data/repository/crypto/crypto_repository_impl.dart';
import 'package:currency_app/data/source/remote/service/crypto_service.dart';
import 'package:dio/dio.dart';

import '../../../data/repository/sqflite/SqfLiteRepositoryImpl.dart';
import '../../../data/repository/sqflite/model/CryptoModelSqfLite.dart';
import 'event.dart';
import 'state.dart';

class CryptoPageBloc extends Bloc<CryptoPageEvent, CryptoPageState> {
  final repository = CryptoRepositoryImpl();
  final repository2 = SqfLiteRepositoryImpl();

  CryptoPageBloc() : super(CryptoPageState(status: CryptoPageStatus.initial)) {
    final service = CryptoService();

    on<GetCryptoEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: CryptoPageStatus.loading));
        final result = await service.getCrypto(event.start);
        emit(state.copyWith(status: CryptoPageStatus.success, data: result, list: result!.list));
      } on DioException catch (e) {
        emit(state.copyWith(errorMessage: e.response?.statusMessage, status: CryptoPageStatus.fail));
      }
    });

    on<SearchCryptoEvent>((event, emit) {
      final searchText = event.name.toLowerCase();
      final originalList = state.data!.list;
      if (searchText.isEmpty) {
        emit(state.copyWith(list: originalList));
        return;
      }
      final filteredList =
          originalList?.where((crypto) {
            return crypto.name?.toLowerCase().contains(searchText) == true || crypto.symbol?.toLowerCase().contains(searchText) == true;
          }).toList();
      emit(state.copyWith(list: filteredList));
    });

    on<AddCryptoToFavoriteEvent>((event, emit) async {
      await repository2.addCrypto(CryptoModelSqfLite(cryptoId: event.cryptoId));
    });
  }
}
