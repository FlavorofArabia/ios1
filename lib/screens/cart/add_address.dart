import 'package:easy_localization/easy_localization.dart';

import '../../api/restful_api/auth_api.dart';
import '../../components/primary_button.dart';
import '../../components/secodary_button.dart';
import '../../config/config.dart';
import '../../models/country.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  Function handler;
  AddAddressScreen(this.handler);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  void initState() {
    super.initState();
    getCountries();
  }

  List<Country> countries = [];
  bool _gettingCountries = false;
  int? selectedCountryId;
  getCountries() async {
    countries = [];
    try {
      if (mounted) {
        setState(() {
          _gettingCountries = true;
        });
      }
      final res = await AuthApi.countries();
      if (res['data'] != null && res['data'] is Iterable) {
        for (var i = 0; i < res['data'].length; i++) {
          countries.add(Country.fromMap(res['data'][i]));
        }
      }

      if (mounted) {
        setState(() {
          _gettingCountries = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _gettingCountries = false;
        });
      }
    }
  }

  List<Zone> cities = [];
  bool _gettingCities = false;
  int? selectedCityId;
  getCities() async {
    if (selectedCountryId != null) {
      cities = [];
      try {
        if (mounted) {
          setState(() {
            _gettingCities = true;
          });
        }
        final res = await AuthApi.cities(selectedCountryId);
        if (res['data'] != null) {
          for (var i = 0; i < res['data']['zone'].length; i++) {
            cities.add(Zone.fromJson(res['data']['zone'][i]));
          }
        }
        if (mounted) {
          setState(() {
            _gettingCities = false;
          });
        }
      } catch (err) {
        print(err);
        if (mounted) {
          setState(() {
            _gettingCities = false;
          });
        }
      }
    }
  }

  String? city;
  String? address1;

  bool _addingAddress = false;
  addAddress(address) async {
    try {
      if (selectedCountryId == null || selectedCityId == null) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('اختر المدينة'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (city == null || city == '' || address1 == null || address1 == '') {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ادخل الحي ووصف البيت'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (mounted) {
        setState(() {
          _addingAddress = true;
        });
      }
      final res = await AuthApi.addAddress(address);
      if (res['data'] != null && res['error'].length == 0) {
        widget.handler();
        Navigator.pop(context);
      } else if (res['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? ''),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _addingAddress = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _addingAddress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Directionality(
        //   textDirection: TextDirection.rtl,
        //   child:
        Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'اضافة عنوان',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'GE',
          ),
        ),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: [
            Text(
              'اختر الدولة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Material(
                shadowColor: Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(8),
                child: _gettingCountries
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : countries.length == 0
                        ? SecondaryButton(
                            // title: 'اعد المحاولة',
                            title: tr('refresh'),
                            onTap: getCountries,
                            borderSize: 0,
                          )
                        : new DropdownButton<String>(
                            isExpanded: true,
                            items: countries.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(
                                  item.name!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                value: item.countryId.toString(),
                              );
                            }).toList(),
                            hint: Text('اختر'),
                            onChanged: (newVal) {
                              setState(() {
                                selectedCountryId =
                                    int.tryParse(newVal.toString());
                              });
                              getCities();
                            },
                            value: selectedCountryId != null
                                ? selectedCountryId.toString()
                                : null,
                          )
                //  TextFormField(
                //   initialValue: 'مصر',
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(
                //       horizontal: 10,
                //       vertical: 0,
                //     ),
                //     enabledBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.white),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //   ),
                //   onChanged: (value) {
                //     country = value;
                //   },
                // ),
                ),
            SizedBox(height: 10),
            selectedCountryId != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'اختر المدينة',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                              shadowColor: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.circular(8),
                              child: _gettingCities
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : cities.length == 0
                                      ? SecondaryButton(
                                          // title: 'اعد المحاولة',
                                          title: tr('refresh'),
                                          onTap: getCities,
                                          borderSize: 0,
                                        )
                                      : new DropdownButton<String>(
                                          isExpanded: true,
                                          items: cities.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(
                                                item.name!,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              value: item.zoneId.toString(),
                                            );
                                          }).toList(),
                                          hint: Text('اختر'),
                                          onChanged: (newVal) {
                                            setState(() {
                                              selectedCityId = int.tryParse(
                                                  newVal.toString());
                                            });
                                          },
                                          value: selectedCityId != null
                                              ? selectedCityId.toString()
                                              : null,
                                        )

                              // child: TextFormField(
                              //   initialValue: 'القاهرة',
                              //   decoration: InputDecoration(
                              //     contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 10,
                              //       vertical: 0,
                              //     ),
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.white),
                              //       borderRadius: BorderRadius.circular(30),
                              //     ),
                              //   ),
                              //   onChanged: (value) {
                              //     city = value;
                              //   },
                              // ),
                              ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                : Container(),
            Text(
              'اختر الحي',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Material(
              shadowColor: Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(8),
              child: TextFormField(
                initialValue: '',
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  city = value;
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'وصف البيت',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Material(
              shadowColor: Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(8),
              child: TextFormField(
                initialValue: '',
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  address1 = value;
                },
              ),
            ),
            SizedBox(height: 10),
            // Text(
            //   'الرمز البريدي',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            // Material(
            //   shadowColor: Color(0xffF6F6F6),
            //   borderRadius: BorderRadius.circular(8),
            //   child: TextFormField(
            //     initialValue: '',
            //     decoration: InputDecoration(
            //       contentPadding: EdgeInsets.symmetric(
            //         horizontal: 10,
            //         vertical: 0,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(color: Colors.white),
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 10),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset(Images.DropPin),
            //       SizedBox(width: 10),
            //       Text('حدد موقعك من الخريطة'),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            _addingAddress
                ? Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    backColor: Theme.of(context).primaryColor,
                    height: 30,
                    title: 'تأكيد العنوان',
                    textWeight: FontWeight.bold,
                    onTap: () {
                      addAddress(
                        {
                          'firstname': Globals.user.firstName! + ' ',
                          'lastname': Globals.user.lastName,
                          'telephone': Globals.user.telephone,
                          'address_1': address1,
                          'zone_id': selectedCityId,
                          'country_id': selectedCountryId,
                          'city': city,
                        },
                      );
                      // widget.handler(
                      //   selectedCountryId,
                      //   selectedCityId,
                      //   city,
                      //   address1,
                      // );
                      // Navigator.pop(context);
                    },
                  ),
          ],
        ),
      ),
      // ),
    );
  }
}
