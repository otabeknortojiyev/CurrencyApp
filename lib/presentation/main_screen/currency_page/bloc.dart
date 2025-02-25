import 'package:bloc/bloc.dart';
import 'package:currency_app/data/repository/shared_pref/shared_pref_repository_impl.dart';
import 'package:currency_app/data/repository/sqflite/SqfLiteRepositoryImpl.dart';
import 'package:currency_app/data/repository/sqflite/model/CurrencyModelSqfLite.dart';
import 'package:dio/dio.dart';

import '../../../data/source/remote/service/currency_service.dart';
import 'event.dart';
import 'state.dart';

class CurrencyPageBloc extends Bloc<CurrencyPageEvent, CurrencyPageState> {
  final repository = SharedPrefRepositoryImpl();
  final repository2 = SqfLiteRepositoryImpl();

  CurrencyPageBloc() : super(CurrencyPageState(status: CurrencyPageStatus.initial)) {
    final service = CurrencyService();

    on<GetCurrencyEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: CurrencyPageStatus.loading));
        final result = await service.getCurrency();
        final langStatus = await repository.getLanguage();
        emit(state.copyWith(status: CurrencyPageStatus.success, data: result, langStatus: langStatus));
      } on DioException catch (e) {
        emit(state.copyWith(errorMessage: e.response?.statusMessage, status: CurrencyPageStatus.fail));
      }
    });

    on<GetCurrencyByDateEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: CurrencyPageStatus.loading));
        final result = await service.getCurrencyByDate(event.date);
        emit(state.copyWith(status: CurrencyPageStatus.success, data: result));
      } on DioException catch (e) {
        emit(state.copyWith(errorMessage: e.response?.statusMessage, status: CurrencyPageStatus.fail));
      }
    });

    on<ChangeLanguageEvent>((event, emit) {
      repository.setLanguage(event.status);
      emit(state.copyWith(langStatus: event.status, status: CurrencyPageStatus.success));
    });

    on<ConvertEvent>((event, emit) {
      emit(state.copyWith(converted: event.converted));
    });

    on<ChangeConvertEvent>((event, emit) {
      emit(state.copyWith(firstCurrency: event.firstCurrency, secondCurrency: event.secondCurrency));
    });

    on<AddCurrencyToFavoriteEvent>((event, emit) async {
      await repository2.addCurrency(CurrencyModelSqfLite(ccy: event.ccy));
    });
  }
}
