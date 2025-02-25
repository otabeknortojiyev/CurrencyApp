import 'package:bloc/bloc.dart';
import 'package:currency_app/data/repository/shared_pref/shared_pref_repository_impl.dart';
import 'package:currency_app/data/repository/sqflite/SqfLiteRepositoryImpl.dart';
import 'package:currency_app/data/source/remote/response/currency_response.dart';
import 'package:dio/dio.dart';

import '../../../data/source/remote/response/crypto_response_by_id.dart';
import '../../../data/source/remote/service/crypto_service.dart';
import '../../../data/source/remote/service/currency_service.dart';
import 'event.dart';
import 'state.dart';

class FavoritePageBloc extends Bloc<FavoritePageEvent, FavoritePageState> {
  FavoritePageBloc() : super(FavoritePageState(currencyStatus: FavoriteCurrencyPageStatus.initial)) {
    final repository = SqfLiteRepositoryImpl();
    final repository2 = SharedPrefRepositoryImpl();
    final currencyService = CurrencyService();
    final cryptoService = CryptoService();

    on<GetFavoriteCurrencyEvent>((event, emit) async {
      try {
        /*
        Removed because favorite currency tab blinking while loading currencies
        emit(state.copyWith(currencyStatus: FavoriteCurrencyPageStatus.loading));
        */
        var lang = await repository2.getLanguage();
        var currencies = await repository.getAllCurrency();
        if (currencies.isEmpty) {
          emit(state.copyWith(currencyStatus: FavoriteCurrencyPageStatus.success, currencyData: [], langStatus: lang));
          return;
        }
        List<Future<CurrencyResponse>> futures =
            currencies.map((currency) async {
              var result = await currencyService.getCurrencyByCodeAndDate(currency.ccy, event.date);
              return result[0];
            }).toList();
        List<CurrencyResponse> list = await Future.wait(futures);
        emit(state.copyWith(currencyStatus: FavoriteCurrencyPageStatus.success, currencyData: list, langStatus: lang));
      } on DioException catch (e) {
        emit(state.copyWith(currencyErrorMessage: e.response?.statusMessage, currencyStatus: FavoriteCurrencyPageStatus.fail));
      } catch (e) {
        emit(state.copyWith(currencyErrorMessage: 'Произошла неизвестная ошибка', currencyStatus: FavoriteCurrencyPageStatus.fail));
      }
    });

    on<ConvertFavoriteCurrencyEvent>((event, emit) {
      emit(state.copyWith(converted: event.converted));
    });

    on<ChangeFavoriteConvertEvent>((event, emit) {
      emit(state.copyWith(firstCurrency: event.firstCurrency, secondCurrency: event.secondCurrency));
    });

    on<DeleteFavoriteCurrencyEvent>((event, emit) async {
      try {
        emit(state.copyWith(currencyStatus: FavoriteCurrencyPageStatus.loading));
        await repository.deleteCurrency(event.ccy);
        var currentList = state.currencyData!;
        List<CurrencyResponse> newList = currentList.where((currency) => currency.ccy != event.ccy).toList();
        emit(state.copyWith(currencyData: newList, currencyStatus: FavoriteCurrencyPageStatus.success));
      } catch (e) {
        emit(state.copyWith(currencyStatus: FavoriteCurrencyPageStatus.fail));
      }
    });

    on<GetFavoriteCryptoEvent>((event, emit) async {
      try {
        emit(state.copyWith(cryptoStatus: FavoriteCryptoPageStatus.loading));
        var cryptos = await repository.getAllCrypto();
        print("SQFLITE ISHLAYAPTI");
        if (cryptos.isEmpty) {
          emit(state.copyWith(cryptoStatus: FavoriteCryptoPageStatus.success, cryptoData: []));
          return;
        }
        List<String> idList = cryptos.map((crypto) => crypto.cryptoId).toList();
        List<CryptoResponseById>? futures = await cryptoService.getCryptoById(idList);
        emit(state.copyWith(cryptoStatus: FavoriteCryptoPageStatus.success, cryptoData: futures));
      } on DioException catch (e) {
        emit(state.copyWith(cryptoErrorMessage: e.response?.statusMessage, cryptoStatus: FavoriteCryptoPageStatus.fail));
      } catch (e) {
        emit(state.copyWith(cryptoErrorMessage: 'Произошла неизвестная ошибка', cryptoStatus: FavoriteCryptoPageStatus.fail));
      }
    });

    on<DeleteFavoriteCryptoEvent>((event, emit) async {
      try {
        emit(state.copyWith(cryptoStatus: FavoriteCryptoPageStatus.loading));
        await repository.deleteCrypto(event.cryptoId);
        var currentData = state.cryptoData!;
        List<CryptoResponseById> updatedCryptoList = currentData.where((crypto) => crypto.id != event.cryptoId.toString()).toList();
        emit(state.copyWith(cryptoData: updatedCryptoList, cryptoStatus: FavoriteCryptoPageStatus.success));
      } catch (e) {
        emit(state.copyWith(cryptoStatus: FavoriteCryptoPageStatus.fail));
      }
    });
  }
}
