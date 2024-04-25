import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:madfun_app/components/venue_bottom_sheet.dart';
import 'package:madfun_app/models/event/event_data.dart';
import 'package:madfun_app/models/event/shows_data.dart';
import 'package:madfun_app/models/event/shows_venue.dart';
import 'package:madfun_app/models/event/ticket_types.dart';
import 'package:madfun_app/services/api_service.dart';

class ShowsTicketScreen extends StatefulWidget {
  final EventData event;
  const ShowsTicketScreen({super.key, required this.event});

  @override
  State<ShowsTicketScreen> createState() => _ShowsTicketScreenState();
}

class _ShowsTicketScreenState extends State<ShowsTicketScreen> {
  late int totalAmount = 0;
  late List<TicketType> selectedTicketTypes = [];
  bool dataFetched = false;
  bool venuesFetched = false;
  late String? displayDate;
  late List<ShowData> showData;
  late List<ShowVenueData> showVenueData;
  late List<TicketType> filteredticketTypes;

  @override
  void initState() {
    super.initState();
    _fetchEventShowData();
  }

  Future<void> _fetchEventShowData() async {
    print(widget.event.eventID);
    showData = await fetchEventShows(widget.event.eventID ?? '');
    if (showData.isEmpty) {
      throw Exception('No show data available');
    }

    // Fetch show venue data
    showVenueData = await fetchEventShowVenue(showData[0].eventShowID);
    if (showVenueData.isEmpty) {
      throw Exception('No show venue data available');
    }

    // Fetch ticket types
    List<TicketType> ticketTypes =
        await fetchVenueTicketTypes(showVenueData[0].eventShowVenueID);

    filteredticketTypes = ticketTypes != null
        ? ticketTypes.where((ticket) => ticket.status == '1').toList()
        : [];
    if (ticketTypes.isEmpty) {
      throw Exception('No ticket types available');
    }

    setState(() {
      dataFetched = true;
    });
  }

  // Future<void> _fetchShowVenueData(String showID) async {
  //   // Fetch show venue data
  //   showVenueData = await fetchEventShowVenue(showID);
  //   if (showVenueData.isEmpty) {
  //     throw Exception('No show venue data available');
  //   }

  //   // Fetch ticket types
  //   List<TicketType> ticketTypes =
  //       await fetchVenueTicketTypes(showVenueData[0].eventShowVenueID);

  //   filteredticketTypes = ticketTypes;
  //   if (ticketTypes.isEmpty) {
  //     throw Exception('No ticket types available');
  //   }

  //   setState(() {
  //     venuesFetched = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xffE9EBEE),
              child: Icon(Icons.chevron_left, color: Colors.black)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Event Tickets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xffE9EBEE),
            child: IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: () {
                //share event ticket
              },
            ),
          ),
          SizedBox(width: 20),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            color: Colors.white,
            height: 80.0,
            padding: EdgeInsets.only(bottom: 10, right: 16, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.7,
                      child: Text(
                        widget.event.eventName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            height: 2.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.event.posterURL ?? ''),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: dataFetched
          ? Container(
              color: Color(0xffF3F5F8),
              padding: EdgeInsets.all(10),
              height: size.height * 0.7,
              child: _buildShowsList())
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomSheet: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 48,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Color(0x7F101820),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0.10,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'KES ${totalAmount.toString()}',
                      style: TextStyle(
                        color: Color(0xFF101820),
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  print(totalAmount);
                  print(selectedTicketTypes.length);
                  if (totalAmount > 0 && selectedTicketTypes.isNotEmpty) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EventsCheckOut(
                    //       event: widget.event,
                    //       selectedTicketTypes: selectedTicketTypes,
                    //       ticketQuantities: ticketQuantities,
                    //       totalAmount: totalAmount,
                    //     ),
                    //   ),
                    // );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alert'),
                          content: Text('Please select a ticket to buy'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF101820),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF101820)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Checkout",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 0.09,
                        letterSpacing: 0.02,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildShowsList() {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: showData.length,
      itemBuilder: (context, index) {
        ShowData show = showData[index];
        return GestureDetector(
          onTap: () {
            // _fetchShowVenueData(show.eventShowID ?? '');

            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                    initialChildSize: 0.80,
                    maxChildSize: 1,
                    minChildSize: 0.50,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return VenueBottomSheet(
                        event: widget.event,
                        show: show,
                        showVenues: showVenueData,
                        ticketTypes: filteredticketTypes,
                      );
                    });
              },
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              leading: Container(
                padding: EdgeInsets.all(6),
                width: 75,
                decoration: BoxDecoration(
                    color: Color(0xffE9EBEE),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  show.showDate ?? '',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              title: Text(
                widget.event.eventName ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.venue ?? '',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    showVenueData.length > 1
                        ? '+ ${showVenueData.length} more locations'
                        : '+ ${showVenueData.length} more location',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget ShowTicketsBottomSheet(
  //     {required EventData event, required ShowData show}) {
  //   if (dataFetched) {
  //     // ShowVenueData venue = showVenueData[0];
  //     return

  //     Container(
  //       height: MediaQuery.of(context).size.height * 0.75,
  //       child: Column(
  //         children: [
  //           Container(
  //             height: 80,
  //             child: Row(
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.all(6),
  //                   width: 75,
  //                   decoration: BoxDecoration(
  //                       color: Color(0xffE9EBEE),
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: Text(
  //                     show.showDate ?? '',
  //                     style: TextStyle(
  //                         color: Colors.black87,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w400),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   widget.event.eventName ?? '',
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600,
  //                     height: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             height: MediaQuery.of(context).size.height * 0.75,
  //             color: Color(0xffF3F5F8),
  //             child: ListView.builder(
  //               itemCount: showVenueData.length,
  //               itemBuilder: (context, index) {
  //                 ShowVenueData venue = showVenueData[index];
  //                 return ExpansionTile(
  //                   leading: Icon(Icons.location_on),
  //                   title: venue.venueName != null
  //                       ? Text(venue.venueName ?? '')
  //                       : Text(widget.event.venue ?? ''),
  //                   //trailing: Icon( ),
  //                   children: [
  //                     Container(
  //                         height: 200, child: _buildVenueTicketTypesList(venue))
  //                   ],
  //                 );
  //               },
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  // }

  _decideDate(String date) {
    DateTime displayDate = DateTime.parse(date) ?? DateTime.now();

    print('date + ${displayDate}');
    return DateFormat('dd MMM').format(displayDate);
  }

  _decideTime(String date) {
    DateTime displayDate = DateTime.parse(date) ?? DateTime.now();

    print('date + ${displayDate}');
    return DateFormat('hh:mm a').format(displayDate);
  }
}
