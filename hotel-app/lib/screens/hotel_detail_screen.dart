
import 'package:flutter/material.dart';
import 'package:hotel_app/model/cart.dart';
import 'package:hotel_app/model/favorites.dart';
import 'package:hotel_app/model/hotel.dart';
import 'package:hotel_app/widgets/details/facilities.dart';
import 'package:hotel_app/widgets/general/custom_titles.dart';
import 'package:hotel_app/widgets/home/calendar_popup_view.dart';
import 'package:hotel_app/widgets/general/app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../themes/hotel_app_theme.dart';


class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;
  final ScrollController _hotelDetailScrollController = ScrollController();

  HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {


  void handleDateChanges(DateTime startDate, DateTime endDate){

      Hotel newHotel = widget.hotel;
      newHotel.startDate = startDate;
      newHotel.endDate = endDate;

      Provider.of<Cart>(context, listen: false).updateHotel(widget.hotel, newHotel);
  }


  void reserveHotel(Hotel hotel){
      Provider.of<Cart>(context, listen: false).addHotelToCart(hotel);

      // alert the user
    showDialog(context: context, builder: (context) => const AlertDialog(
      title: Text("Agriventure Reserved!") ,
      content: Text("Check your cart"),
    ) );

  }

  void addHotelToFavorites(Hotel hotel){
      Provider.of<Favorites>(context, listen: false).addToFavories(hotel);

      // alert the user
    showDialog(context: context, builder: (context) => const AlertDialog(
      title: Text("Location added to favorites!") ,
      content: Text("Check your favorites"),
    ) );

  }

  void removeHotelFromFavorites(Hotel hotel){
      Provider.of<Favorites>(context, listen: false).removeFromFavories(hotel);

      // alert the user
    showDialog(context: context, builder: (context) => const AlertDialog(
      title: Text("Removed Successfully!")
    ) );

  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          backgroundColor: HotelAppTheme.buildLightTheme().canvasColor,
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Consumer<Favorites>(builder: (context, value, child) => Column(children: <Widget>[
                  CustomAppBar(title: "Details"),
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18.0)),
                                    child: Container(
                                      // color: Colors.yellow,
                                      height: 240, width: 200,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18.0)),
                                    child: Image(
                                      image: AssetImage(widget.hotel.imagePath),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                    top: 160,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: HotelAppTheme.buildLightTheme()
                                              .colorScheme
                                              .surface,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(
                                            left: 12, right: 12),
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 8,
                                            bottom: 8),
                                        child:
                                            HotelDetailTitle(widget: widget)))
                              ],
                            ),
                            CustomScreenTitle(title: "Address"),
                            Container(
                              width: 300,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(widget.hotel.address)
                            ),
                            CustomScreenTitle(title: "About"),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                 
                                  widget.hotel.about)),
          

                                        CustomScreenTitle(title: "Facilities"),
                            FacilitiesChip(facilities: widget.hotel.facilities),
                            ReserveDate(onDateChanges: handleDateChanges,),
                            Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () => reserveHotel(widget.hotel),
                                          icon: Icon(
                                              Icons.add_shopping_cart_sharp),
                                          label: Text("Reserve")),
                                     value.hotelIsFavorite(widget.hotel) ?
                                     
                                     TextButton.icon(
                                          onPressed: () => removeHotelFromFavorites(widget.hotel),
                                          icon: Icon(Icons.favorite_border_rounded),
                                          label: Text("Remove")) : TextButton.icon(
                                          onPressed: () => addHotelToFavorites(widget.hotel),
                                          icon: Icon(Icons.favorite),
                                          label: Text("Add to Favorites"))
                                    ],
                                  )),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 16),
                        color: HotelAppTheme.buildLightTheme()
                            .colorScheme
                            .background,
                      ),
                    ],
                  ))
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}



class HotelDetailTitle extends StatelessWidget {
  const HotelDetailTitle({
    super.key,
    required this.widget,
  });

  final HotelDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.hotel.titleTxt,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Text(widget.hotel.rating.toString())
                          ],
                        ),
                        SizedBox(width: 12,),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey[600],
                            ),
                            Text(widget.hotel.dist.toString() + " km")
                          ],
                        )
                      ],
                    ),
                  )
                ]),
              ],
            ),
            Column(
              children: [
                Text("\$55",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: HotelAppTheme.buildLightTheme().primaryColor)),
                Text("/night")
              ],
            )
          ],
        ));
  }
}

class ReserveDate extends StatefulWidget {

  final Function onDateChanges;
  const ReserveDate({super.key, required this.onDateChanges});

  @override
  State<ReserveDate> createState() => _ReserveDateState();
}

class _ReserveDateState extends State<ReserveDate> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });

          widget.onDateChanges(startDate, endDate);
        },
        onCancelClick: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            // setState(() {
            //   isDatePopupOpen = true;
            // });
            showDemoDialog(context: context);
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose date',
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                      color: Colors.grey.withOpacity(0.8)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
