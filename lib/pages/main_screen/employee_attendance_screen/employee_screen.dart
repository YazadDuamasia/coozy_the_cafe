import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/staff_management_bloc/employee_cubit/employee_cubit.dart';
import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:coozy_the_cafe/pages/startup_screens/loading_page/loading_page.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/country_pickers/country.dart';
import 'package:coozy_the_cafe/widgets/phone_number_text_form_widget/phone_number.dart';
import 'package:coozy_the_cafe/widgets/phone_number_text_form_widget/phone_number_text_form_field.dart';
import 'package:coozy_the_cafe/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen>
    with SingleTickerProviderStateMixin {
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(debugLabel: "employeeScreenScrollController");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EmployeeCubit>(context).fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<EmployeeCubit, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message ?? "")));
            }
          },
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const LoadingPage();
            } else if (state is EmployeeLoaded) {
              return Scrollbar(
                thumbVisibility: true,
                interactive: true,
                radius: const Radius.circular(10.0),
                controller: scrollController,
                child: RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<EmployeeCubit>(context).fetchEmployees();
                  },
                  child: SlidableAutoCloseBehavior(
                    child: ListView.builder(
                      itemCount: state.employees?.length ?? 0,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Employee? employee = state.employees![index];
                        Constants.debugLog(EmployeeScreen,
                            "Employee$index:${employee.toString()}");
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 10, top: 5),
                          child: Slidable(
                            key: ValueKey(index),
                            closeOnScroll: true,

                            // The end action pane is the one at the right or the bottom side.
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (BuildContext context) async {
                                    Constants.showLoadingDialog(context);
                                    _showEditEmployeeDialog(context, employee);
                                  },
                                  backgroundColor: Colors.lightBlueAccent,
                                  foregroundColor: Colors.white,
                                  icon: MdiIcons.circleEditOutline,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                  ),
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  autoClose: true,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (BuildContext ctx) {
                                    Constants.customPopUpDialogMessage(
                                      classObject: EmployeeScreen,
                                      context: this.context,
                                      titleIcon: Icon(
                                        Icons.info_outline,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title:
                                          "${AppLocalizations.of(context)?.translate(StringValue.employee_screen_delete_title_dialog) ?? "Are you sure ?"}",
                                      descriptions:
                                          "${AppLocalizations.of(context)?.translate(StringValue.employee_screen_delete_dialog_subTitle) ?? "Do you really want to delete this employee information? You will not be able to undo this action."}",
                                      actions: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              "${AppLocalizations.of(context)!.translate(StringValue.common_cancel)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colors.white
                                                        : null,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(this.context),
                                          ),
                                          TextButton(
                                            child: Text(
                                              "${AppLocalizations.of(context)!.translate(StringValue.common_okay)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colors.white
                                                        : null,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(this.context);
                                              BlocProvider.of<EmployeeCubit>(
                                                      this.context)
                                                  .deleteEmployee(employee.id!);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        employee.name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Position: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text: employee.position ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        Uri? uri = Uri.tryParse(
                                            'tel:${employee.phoneNumber?.trim() ?? ''}');
                                        try {
                                          if (await UrlLauncher.canLaunchUrl(
                                              uri!)) {
                                            await UrlLauncher.launchUrl(uri);
                                          } else {
                                            throw 'Could not launch ${uri.data.toString()}';
                                          }
                                        } catch (e) {
                                          Flushbar(
                                            message:
                                                "Failed to make call.Please try again.",
                                            icon: Icon(
                                              Icons.error,
                                              size: 28.0,
                                              color: Colors.red,
                                            ),
                                            margin: EdgeInsets.all(5.0),
                                            flushbarStyle:
                                                FlushbarStyle.FLOATING,
                                            flushbarPosition:
                                                FlushbarPosition.BOTTOM,
                                            textDirection:
                                                Directionality.of(context),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            duration: Duration(seconds: 3),
                                            leftBarIndicatorColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ).show(context);

                                          Clipboard.setData(ClipboardData(
                                                  text:
                                                      "${employee.phoneNumber?.trim()}"))
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${employee.phoneNumber?.trim()} has been copy to your Clipboard.'),
                                              ),
                                            );
                                            print(
                                                'Error launching phone call: $e');
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.phone,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(employee.phoneNumber
                                                      ?.trim() ??
                                                  ''),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Start Shift Time: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text: employee
                                                          .startWorkingTime ??
                                                      "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'End Shift Time: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text:
                                                      employee.endWorkingTime ??
                                                          "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Total Working time: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text: '${ DateUtil.calculateRemainingTime(
                                                      fromTime: employee.startWorkingTime,
                                                      toTime: employee.endWorkingTime,
                                                      format: DateUtil.TIME_FORMAT2) ??
                                                      "N/A"}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Visibility(
                                      visible: employee.creationDate != null,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Creation Date: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    TextSpan(
                                                      text: employee
                                                              .creationDate ??
                                                          "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          employee.modificationDate != null,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Modification date: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    TextSpan(
                                                      text: employee
                                                              .modificationDate ??
                                                          "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            return const Center(child: Text('No Employees'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Constants.showLoadingDialog(context);
            await _showAddEmployeeDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showAddEmployeeDialog(BuildContext context) async {
    final nameController = TextEditingController(text: "");
    final positionController = TextEditingController(text: "");
    final phoneNumberController = TextEditingController(text: "");
    final joiningDateController = TextEditingController(text: "");
    final leavingDateController = TextEditingController(text: "");
    final startWorkingTimeController = TextEditingController(text: "");
    final endWorkingTimeController = TextEditingController(text: "");

    final nameFocusNode = FocusNode();
    final positionFocusNode = FocusNode();
    final phoneNumberFocusNode = FocusNode();
    final joiningDateFocusNode = FocusNode();
    final leavingDateFocusNode = FocusNode();
    final startWorkingTimeFocusNode = FocusNode();
    final endWorkingTimeFocusNode = FocusNode();

    DateTime? joiningDate = DateTime.now();
    DateTime? leavingDate = null;
    TimeOfDay? startWorkingTime = TimeOfDay.now();
    TimeOfDay? endWorkingTime = TimeOfDay.now();

    GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

    Country? selectedCountry;
    String? selectedCountryValue = "";
    InternetStatus? connectionStatus =
        await InternetConnection().internetStatus;
    if (connectionStatus == InternetStatus.connected) {
      if (Constants.getIsMobileApp() == true) {
        try {
          final List<Locale> systemLocales =
              WidgetsBinding.instance.window.locales;
          String? isoCountryCode = systemLocales.first.countryCode;
          selectedCountry =
              CountryPickerUtils.getCountryByIsoCode(isoCountryCode!);
        } catch (e) {
          Constants.debugLog(EmployeeScreen,
              "updateCountryIosCode:getIsMobileApp:Error:${e.toString()}");
          var data = CountryPickerUtils.getCountryByIso3Code("IND");
          selectedCountry = data;
        }
      } else {
        selectedCountry = await getPublicIp();
      }
    } else {
      var data = CountryPickerUtils.getCountryByIso3Code("IND");
      selectedCountry = data;
    }

    final ValueNotifier<String> totalWorkingTimeNotifier =
        ValueNotifier<String>('N/A');
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
          toTime: startWorkingTimeController.text,
          fromTime: endWorkingTimeController.text,
          format: DateUtil.TIME_FORMAT2);
      totalWorkingTimeNotifier.value = totalWorkingTime ?? 'N/A';
      setState(() {});
    }

    Navigator.pop(context);

    startWorkingTimeController.addListener(_updateTotalWorkingTime);
    endWorkingTimeController.addListener(_updateTotalWorkingTime);

    await showModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0), bottom: Radius.circular(0.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.35,
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Add Employee",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: nameController,
                                focusNode: nameFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter name";
                                  }
                                  return null;
                                },
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: positionController,
                                decoration: const InputDecoration(
                                    labelText: 'Position'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter position of employee";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: PhoneNumberTextFormField(
                                controller: phoneNumberController,
                                focusNode: phoneNumberFocusNode,
                                showDropdownIcon: true,
                                showCountryFlag: true,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(9),
                                  isDense: true,
                                  labelText: "Phone Number",
                                  hintText: "Enter your phone number",
                                ),
                                onCountryChanged: (Country country) {
                                  Constants.debugLog(EmployeeScreen,
                                      'Country changed to: ' + country.name);
                                  selectedCountryValue =
                                      "+${country.phoneCode} ${phoneNumberController.text}";
                                  setState(() {});
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                invalidNumberMessage: AppLocalizations.of(
                                            context)
                                        ?.translate(StringValue
                                            .common_common_phoneNumber_validator_error_msg) ??
                                    "Please enter a valid phone number.",
                                onChanged: (PhoneNumber? number) {
                                  Constants.debugLog(
                                      EmployeeScreen, "number:$number");
                                  if (number == null ||
                                      (number.isValidNumber() == false)) {
                                    selectedCountryValue = "";
                                  } else {
                                    Constants.debugLog(
                                        EmployeeScreen,
                                        'countryISOCode: ' +
                                            number.countryISOCode +
                                            "\ncountryCode: " +
                                            number.countryCode +
                                            "\nNumber: " +
                                            number.number);
                                    selectedCountryValue =
                                        "${number.countryCode} ${number.number}";
                                  }
                                },
                                initialCountryCode:
                                    selectedCountry?.isoCode ?? "IN",
                                priorityList: [
                                  CountryPickerUtils.getCountryByIsoCode('IN'),
                                  CountryPickerUtils.getCountryByIsoCode('US'),
                                ],
                                onSubmitted: (String value) {
                                  Future.microtask(() => FocusScope.of(context)
                                      .requestFocus(new FocusNode()));
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: joiningDateController,
                                focusNode: joiningDateFocusNode,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? initialDate = joiningDate;
                                  DateTime? tempPickedDate = initialDate;
                                  await showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ColoredBox(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .40,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text('Done'),
                                                    onPressed: () {
                                                      setState(() {
                                                        joiningDate =
                                                            tempPickedDate!;
                                                        joiningDateController
                                                                .text =
                                                            DateUtil.dateToString(
                                                                joiningDate,
                                                                DateUtil
                                                                    .DATE_FORMAT9)!;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  dateOrder:
                                                      DatePickerDateOrder.dmy,
                                                  initialDateTime: initialDate,
                                                  onDateTimeChanged:
                                                      (DateTime newDate) {
                                                    tempPickedDate = newDate;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText: "Joining Date",
                                  suffix: Visibility(
                                    visible: joiningDateController.text !=
                                            null ||
                                        joiningDateController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          joiningDateController.clear();
                                          joiningDate = null;
                                        });
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return "Please enter join date";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: leavingDateController,
                                focusNode: leavingDateFocusNode,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? initialDate = leavingDate;
                                  DateTime? tempPickedDate = initialDate;
                                  await showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ColoredBox(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .40,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text('Done'),
                                                    onPressed: () {
                                                      setState(() {
                                                        leavingDate =
                                                            tempPickedDate!;
                                                        leavingDateController
                                                                .text =
                                                            DateUtil.dateToString(
                                                                leavingDate,
                                                                DateUtil
                                                                    .DATE_FORMAT9)!;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  dateOrder:
                                                      DatePickerDateOrder.dmy,
                                                  initialDateTime: initialDate,
                                                  onDateTimeChanged:
                                                      (DateTime newDate) {
                                                    tempPickedDate = newDate;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText: "leaving Date",
                                  suffix: Visibility(
                                    visible: leavingDateController.text !=
                                            null ||
                                        leavingDateController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          leavingDateController.clear();
                                          leavingDate = null;
                                        });
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode: AutovalidateMode.disabled,
                                validator: (value) {
                                  if (value == null) {
                                    return "Please enter leaving date";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: startWorkingTimeController,
                                focusNode: startWorkingTimeFocusNode,
                                readOnly: true,
                                onTap: () async {
                                  DateTime now = DateTime.now();
                                  DateTime initialDateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      startWorkingTime!.hour,
                                      startWorkingTime!.minute);
                                  DateTime? tempPickedDateTime =
                                      initialDateTime;

                                  await showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ColoredBox(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .40,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text('Done'),
                                                    onPressed: () {
                                                      setState(() {
                                                        startWorkingTime =
                                                            TimeOfDay(
                                                          hour:
                                                              tempPickedDateTime
                                                                      ?.hour ??
                                                                  0,
                                                          minute:
                                                              tempPickedDateTime
                                                                      ?.minute ??
                                                                  0,
                                                        );
                                                        startWorkingTimeController
                                                                .text =
                                                            DateUtil.formatTimeOfDay(
                                                                startWorkingTime!,
                                                                DateUtil
                                                                    .TIME_FORMAT2);
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  initialDateTime:
                                                      initialDateTime,
                                                  onDateTimeChanged:
                                                      (DateTime newDateTime) {
                                                    tempPickedDateTime =
                                                        newDateTime;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText: "Starting Shift Time",
                                  suffix: Visibility(
                                    visible: startWorkingTimeController.text !=
                                            null ||
                                        startWorkingTimeController
                                            .text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          startWorkingTime = null;
                                          startWorkingTimeController.clear();
                                        });
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return "Please enter start working time.";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: endWorkingTimeController,
                                focusNode: endWorkingTimeFocusNode,
                                readOnly: true,
                                onTap: () async {
                                  DateTime now = DateTime.now();
                                  DateTime initialDateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      endWorkingTime!.hour,
                                      endWorkingTime!.minute);
                                  DateTime? tempPickedDateTime =
                                      initialDateTime;

                                  await showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ColoredBox(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .40,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text('Done'),
                                                    onPressed: () async {
                                                      endWorkingTime =
                                                          TimeOfDay(
                                                        hour: tempPickedDateTime
                                                                ?.hour ??
                                                            0,
                                                        minute:
                                                            tempPickedDateTime
                                                                    ?.minute ??
                                                                0,
                                                      );
                                                      endWorkingTimeController
                                                              .text =
                                                          DateUtil.formatTimeOfDay(
                                                              endWorkingTime!,
                                                              DateUtil
                                                                  .TIME_FORMAT2);
                                                      setState(() {});

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  initialDateTime:
                                                      initialDateTime,
                                                  onDateTimeChanged:
                                                      (DateTime newDateTime) {
                                                    tempPickedDateTime =
                                                        newDateTime;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText: "Ending Shift Time",
                                  suffix: Visibility(
                                    visible: startWorkingTimeController.text !=
                                            null ||
                                        startWorkingTimeController
                                            .text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        endWorkingTime = null;
                                        endWorkingTimeController.clear();
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return "Please enter end shift time.";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ValueListenableBuilder<String>(
                            valueListenable: totalWorkingTimeNotifier,
                            builder: (context, totalWorkingTime, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Total Working time: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: '${totalWorkingTime}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final isValid =
                                      _formKey.currentState!.validate();
                                  if (!isValid) {
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  final employee = Employee(
                                      name: nameController.text,
                                      position: positionController.text,
                                      phoneNumber: selectedCountryValue,
                                      joiningDate: joiningDateController.text,
                                      leavingDate: leavingDateController.text,
                                      creationDate: DateUtil.dateToString(
                                          DateTime.now(),
                                          DateUtil.DATE_FORMAT15),
                                      startWorkingTime:
                                          startWorkingTimeController.text,
                                      endWorkingTime:
                                          endWorkingTimeController.text,
                                      workingHours: DateUtil
                                          .calculateRemainingTime(
                                              format: DateUtil.DATE_FORMAT15,
                                              fromTime:
                                                  startWorkingTimeController
                                                      .text,
                                              toTime: endWorkingTimeController
                                                  .text));
                                  Constants.debugLog(EmployeeScreen,
                                      "_showAddEmployeeDialog:Add:employee:${employee.toString()}");
                                  context
                                      .read<EmployeeCubit>()
                                      .addEmployee(employee);

                                  Navigator.of(context).pop();
                                },
                                child: const Text('Add'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditEmployeeDialog(
      BuildContext context, Employee employee) async {
    final nameController = TextEditingController(text: employee.name ?? "");
    final phoneNumberController = TextEditingController(text: "");
    final positionController =
        TextEditingController(text: employee.position ?? "");
    final joiningDateController =
        TextEditingController(text: employee.joiningDate ?? "");
    final leavingDateController =
        TextEditingController(text: employee.leavingDate ?? "");
    final startWorkingTimeController =
        TextEditingController(text: employee.startWorkingTime ?? "");
    final endWorkingTimeController =
        TextEditingController(text: employee.endWorkingTime ?? "");

    final nameFocusNode = FocusNode();
    final positionFocusNode = FocusNode();
    final phoneNumberFocusNode = FocusNode();
    final joiningDateFocusNode = FocusNode();
    final leavingDateFocusNode = FocusNode();
    final startWorkingTimeFocusNode = FocusNode();
    final endWorkingTimeFocusNode = FocusNode();

    GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

    DateTime? joiningDate = DateUtil.stringToDateTime(
        employee.joiningDate ?? "", DateUtil.DATE_FORMAT9);
    DateTime? leavingDate = DateUtil.stringToDateTime(
        employee.leavingDate ?? "", DateUtil.DATE_FORMAT9);
    TimeOfDay? startWorkingTime = DateUtil.parseTimeOfDay(
        employee.startWorkingTime ?? "", DateUtil.TIME_FORMAT2);
    TimeOfDay? endWorkingTime = DateUtil.parseTimeOfDay(
        employee.endWorkingTime ?? "", DateUtil.TIME_FORMAT2);

    var phoneNumberParts =
        employee.phoneNumber == null || employee.phoneNumber!.isEmpty
            ? []
            : employee.phoneNumber!.split(" ");

    Country? selectedCountry;
    String? selectedCountryValue = "";
    selectedCountry = CountryPickerUtils.getCountryByPhoneCode(
        "${phoneNumberParts[0] == null ? "91" : phoneNumberParts[0].toString().split("+").last}");
    selectedCountryValue =
        "${selectedCountry.phoneCode} ${phoneNumberParts.last}";
    phoneNumberController.text = "${phoneNumberParts.last ?? ""}";

    final ValueNotifier<String> totalWorkingTimeNotifier =
        ValueNotifier<String>(
            DateUtil.calculateRemainingTime(
                fromTime: employee.startWorkingTime,
                toTime: employee.endWorkingTime,
                format: DateUtil.TIME_FORMAT2) ??
            "N/A");
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
          fromTime: startWorkingTimeController.text,
          toTime: endWorkingTimeController.text,
          format: DateUtil.TIME_FORMAT2);
      totalWorkingTimeNotifier.value = totalWorkingTime ?? 'N/A';
    }

    startWorkingTimeController.addListener(_updateTotalWorkingTime);
    endWorkingTimeController.addListener(_updateTotalWorkingTime);

    Navigator.pop(context);

    await showModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0), bottom: Radius.circular(0.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.35,
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSate) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Edit Employee",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: nameController,
                                  focusNode: nameFocusNode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter name";
                                    }
                                    return null;
                                  },
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: positionController,
                                  decoration: const InputDecoration(
                                      labelText: 'Position'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter position of employee";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: PhoneNumberTextFormField(
                                  controller: phoneNumberController,
                                  focusNode: phoneNumberFocusNode,
                                  showDropdownIcon: true,
                                  showCountryFlag: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(9),
                                    isDense: true,
                                    labelText: "Phone Number",
                                    hintText: "Enter your phone number",
                                  ),
                                  onCountryChanged: (Country country) {
                                    Constants.debugLog(EmployeeScreen,
                                        'Country changed to: ' + country.name);
                                    selectedCountryValue =
                                        "+${country.phoneCode} ${phoneNumberController.text}";
                                    setState(() {});
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  invalidNumberMessage: AppLocalizations.of(
                                              context)
                                          ?.translate(StringValue
                                              .common_common_phoneNumber_validator_error_msg) ??
                                      "Please enter a valid phone number.",
                                  onChanged: (PhoneNumber? number) {
                                    Constants.debugLog(
                                        EmployeeScreen, "number:$number");
                                    if (number == null ||
                                        (number.isValidNumber() == false)) {
                                      selectedCountryValue = "";
                                    } else {
                                      Constants.debugLog(
                                          EmployeeScreen,
                                          'countryISOCode: ' +
                                              number.countryISOCode +
                                              "\ncountryCode: " +
                                              number.countryCode +
                                              "\nNumber: " +
                                              number.number);
                                      selectedCountryValue =
                                          "${number.countryCode} ${number.number}";

                                      phoneNumberController.text =
                                          "${number.number}";
                                      setState(() {});
                                    }
                                  },
                                  initialCountryCode:
                                      selectedCountry?.isoCode ?? "IN",
                                  priorityList: [
                                    CountryPickerUtils.getCountryByIsoCode(
                                        'IN'),
                                    CountryPickerUtils.getCountryByIsoCode(
                                        'US'),
                                  ],
                                  onSubmitted: (String value) {
                                    Future.microtask(() =>
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode()));
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: joiningDateController,
                                  focusNode: joiningDateFocusNode,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? initialDate = joiningDate;
                                    DateTime? tempPickedDate = initialDate;
                                    await showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColoredBox(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .40,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      child: const Text('Done'),
                                                      onPressed: () {
                                                        setState(() {
                                                          joiningDate =
                                                              tempPickedDate!;
                                                          joiningDateController
                                                                  .text =
                                                              DateUtil.dateToString(
                                                                  joiningDate,
                                                                  DateUtil
                                                                      .DATE_FORMAT9)!;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    dateOrder:
                                                        DatePickerDateOrder.dmy,
                                                    initialDateTime:
                                                        initialDate,
                                                    onDateTimeChanged:
                                                        (DateTime newDate) {
                                                      tempPickedDate = newDate;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Joining Date",
                                    suffix: Visibility(
                                      visible: joiningDateController.text !=
                                              null ||
                                          joiningDateController.text.isNotEmpty,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            joiningDateController.clear();
                                            joiningDate = null;
                                          });
                                        },
                                        child: const Icon(Icons.clear),
                                      ),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please enter join date";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: leavingDateController,
                                  focusNode: leavingDateFocusNode,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? initialDate = leavingDate;
                                    DateTime? tempPickedDate = initialDate;
                                    await showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColoredBox(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .40,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      child: const Text('Done'),
                                                      onPressed: () {
                                                        setState(() {
                                                          leavingDate =
                                                              tempPickedDate!;
                                                          leavingDateController
                                                                  .text =
                                                              DateUtil.dateToString(
                                                                  leavingDate,
                                                                  DateUtil
                                                                      .DATE_FORMAT9)!;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    dateOrder:
                                                        DatePickerDateOrder.dmy,
                                                    initialDateTime:
                                                        initialDate,
                                                    onDateTimeChanged:
                                                        (DateTime newDate) {
                                                      tempPickedDate = newDate;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    labelText: "leaving Date",
                                    suffix: Visibility(
                                      visible: leavingDateController.text !=
                                              null ||
                                          leavingDateController.text.isNotEmpty,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            leavingDateController.clear();
                                            leavingDate = null;
                                          });
                                        },
                                        child: const Icon(Icons.clear),
                                      ),
                                    ),
                                  ),
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please enter leaving date";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: startWorkingTimeController,
                                  focusNode: startWorkingTimeFocusNode,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime now = DateTime.now();
                                    DateTime initialDateTime = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        startWorkingTime!.hour,
                                        startWorkingTime!.minute);
                                    DateTime? tempPickedDateTime =
                                        initialDateTime;

                                    await showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColoredBox(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .40,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      child: const Text('Done'),
                                                      onPressed: () {
                                                        startWorkingTime =
                                                            TimeOfDay(
                                                          hour:
                                                              tempPickedDateTime
                                                                      ?.hour ??
                                                                  0,
                                                          minute:
                                                              tempPickedDateTime
                                                                      ?.minute ??
                                                                  0,
                                                        );
                                                        startWorkingTimeController
                                                                .text =
                                                            DateUtil.formatTimeOfDay(
                                                                startWorkingTime!,
                                                                DateUtil
                                                                    .TIME_FORMAT2);
                                                        setState(() {});

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    initialDateTime:
                                                        initialDateTime,
                                                    onDateTimeChanged:
                                                        (DateTime newDateTime) {
                                                      tempPickedDateTime =
                                                          newDateTime;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Starting Shift Time",
                                    suffix: Visibility(
                                      visible:
                                          startWorkingTimeController.text !=
                                                  null ||
                                              startWorkingTimeController
                                                  .text.isNotEmpty,
                                      child: GestureDetector(
                                        onTap: () async {
                                          startWorkingTime = null;
                                          startWorkingTimeController.clear();
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.clear),
                                      ),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please enter start working time.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: endWorkingTimeController,
                                  focusNode: endWorkingTimeFocusNode,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime now = DateTime.now();
                                    DateTime initialDateTime = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        endWorkingTime!.hour,
                                        endWorkingTime!.minute);
                                    DateTime? tempPickedDateTime =
                                        initialDateTime;

                                    await showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColoredBox(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .40,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      child: const Text('Done'),
                                                      onPressed: () async {
                                                        endWorkingTime =
                                                            TimeOfDay(
                                                          hour:
                                                              tempPickedDateTime
                                                                      ?.hour ??
                                                                  0,
                                                          minute:
                                                              tempPickedDateTime
                                                                      ?.minute ??
                                                                  0,
                                                        );
                                                        endWorkingTimeController
                                                                .text =
                                                            DateUtil.formatTimeOfDay(
                                                                endWorkingTime!,
                                                                DateUtil
                                                                    .TIME_FORMAT2);
                                                        setState(() {});

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    initialDateTime:
                                                        initialDateTime,
                                                    onDateTimeChanged:
                                                        (DateTime newDateTime) {
                                                      tempPickedDateTime =
                                                          newDateTime;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Ending Shift Time",
                                    suffix: Visibility(
                                      visible: endWorkingTimeController.text !=
                                              null ||
                                          endWorkingTimeController
                                              .text.isNotEmpty,
                                      child: GestureDetector(
                                        onTap: () async {
                                          endWorkingTime = null;
                                          endWorkingTimeController.clear();
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.clear),
                                      ),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please enter end shift time.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ValueListenableBuilder<String>(
                              valueListenable: totalWorkingTimeNotifier,
                              builder: (context, totalWorkingTime, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Total Working time: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                            TextSpan(
                                              text: '${totalWorkingTime}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final isValid =
                                        _formKey.currentState!.validate();
                                    if (!isValid) {
                                      return;
                                    }
                                    _formKey.currentState!.save();
                                    final updatedEmployee = Employee(
                                      id: employee.id,
                                      name: nameController.text,
                                      position: positionController.text,
                                      phoneNumber: selectedCountryValue,
                                      joiningDate: joiningDateController.text,
                                      leavingDate: leavingDateController.text,
                                      startWorkingTime:
                                          startWorkingTimeController.text,
                                      endWorkingTime:
                                          endWorkingTimeController.text,
                                      modificationDate: DateUtil.dateToString(
                                          DateTime.now(),
                                          DateUtil.DATE_FORMAT15),
                                    );
                                    Constants.debugLog(EmployeeScreen,
                                        "_showAddEmployeeDialog:Add:employee:${updatedEmployee.toString()}");
                                    context
                                        .read<EmployeeCubit>()
                                        .updateEmployee(updatedEmployee);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Update'),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<Country?> getPublicIp() async {
    String? ipv4 = await getPublicIp4();
    if (ipv4 != null) {
      var country_code = await getIpInfo(ipv4);
      Constants.debugLog(
          EmployeeScreen, ":getPublicIp:IPV4:country_code:${country_code}");
      if (country_code != null && country_code.isNotEmpty) {
        var data = CountryPickerUtils.getCountryByIso3Code(country_code);
        return data;
      }
    } else {
      String? ipv6 = await getPublicIp6();
      if (ipv6 != null) {
        var country_code = await getIpInfo(ipv6);
        Constants.debugLog(
            EmployeeScreen, ":getPublicIp:IPV6:country_code:${country_code}");
        if (country_code != null && country_code.isNotEmpty) {
          var data = CountryPickerUtils.getCountryByIso3Code(country_code);
          return data;
        }
      } else {
        // print("No Ip Founded");
        var data = CountryPickerUtils.getCountryByIso3Code("IND");
        return data;
      }
    }
  }

  Future<String?> getPublicIp4() async {
    String? ipv4;
    try {
      http.Response? responseV4 = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );
      if (responseV4.statusCode == 200) {
        final data = jsonDecode(responseV4.body);
        ipv4 = data['ip'] as String;
        // print('Public IPv4 address: $ipv4');
      }
      // else if (responseV4.statusCode == 429) {
      //   await getPublicIp4();
      // }
      else {
        ipv4 = null;
        // print('Failed to get public IPv4 address');
      }
    } on SocketException {
      await getPublicIp4();
    } catch (e) {
      ipv4 = null;
      // print('Failed to get public IPv4 address');
      // print(e);
    }
    return ipv4;
  }

  Future<String?> getPublicIp6() async {
    String? ipv6;
    try {
      http.Response? responseV6 = await http.get(
        Uri.parse("https://api64.ipify.org/?format=json"),
      );
      if (responseV6.statusCode == 200) {
        final data = jsonDecode(responseV6.body);
        ipv6 = data['ip'] as String;
        // print('Public IPv6 address: $ipv6');
      }
      // else if (responseV6.statusCode == 429) {
      //   await getPublicIp6();
      // }
      else {
        ipv6 = null;
        // print('Failed to get public IPv6 address');
      }
    } on SocketException {
      await getPublicIp6();
    } catch (e) {
      ipv6 = null;
      // print('Failed to get public IPv6 address');
      // print(e);
    }
    return ipv6;
  }

  Future<String?> getIpInfo(String ipAddress) async {
    final url = 'https://ipapi.co/$ipAddress/json/';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // final country = data['country_name'] as String;
        final country_code_iso3 = data['country_code_iso3'] as String;
        // final region = data['region'] as String;
        // final city = data['city'] as String;
        // final latitude = data['latitude'] as double;
        // final longitude = data['longitude'] as double;
        // final timezone = data['timezone'] as String;
        // final isp = data['org'] as String;
        //
        // print('Country: $country');
        // print('Region: $region');
        // print('City: $city');
        // print('Latitude: $latitude');
        // print('Longitude: $longitude');
        // print('Time zone: $timezone');
        // print('ISP: $isp');
        return country_code_iso3;
      } else {
        // print('Failed to get IP info');
        return null;
      }
    } on SocketException {
      await getIpInfo(ipAddress);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}
