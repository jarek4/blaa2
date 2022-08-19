import 'package:blaa/ui/widgets/list_ordering_wrapper/list_ordering_wrapper.dart';
import 'package:flutter/material.dart';

class OrderBar extends StatefulWidget {
  const OrderBar({Key? key, required handleOnlyFavorite, required handleOrder})
      : _handleOnlyFavorite = handleOnlyFavorite,
        _handleOrder = handleOrder,
        super(key: key);
  final Function _handleOnlyFavorite, _handleOrder;

  @override
  State<OrderBar> createState() => _OrderBarState();
}

class _OrderBarState extends State<OrderBar> {
  late bool _onlyFavoriteCheckboxValue;
  late bool _isOrderedFromOldest;

  @override
  void initState() {
    _onlyFavoriteCheckboxValue = false;
    _isOrderedFromOldest = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListOrderingWrapper(
      onlyFavoriteCheckbox: Checkbox(
        activeColor: Colors.green.shade400,
        value: _onlyFavoriteCheckboxValue,
        onChanged: (bool? value) {
          setState(() {
            _onlyFavoriteCheckboxValue = !_onlyFavoriteCheckboxValue;
          });
          widget._handleOnlyFavorite(_onlyFavoriteCheckboxValue);
        },
      ),
      fromNewestRadio: Radio(
          activeColor: Colors.green,
          value: false,
          groupValue: _isOrderedFromOldest,
          onChanged: (v) {
            setState(() {
              _isOrderedFromOldest = v;
            });
            widget._handleOrder(_isOrderedFromOldest);
          }),
      fromOldestRadio: Radio(
          activeColor: Colors.indigo,
          value: true,
          groupValue: _isOrderedFromOldest,
          onChanged: (v) {
            setState(() {
              _isOrderedFromOldest = v;
            });
            widget._handleOrder(_isOrderedFromOldest);
          }),
    );
  }
}
