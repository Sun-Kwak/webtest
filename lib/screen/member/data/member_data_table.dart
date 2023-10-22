import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/data_table/custom_grid_column.dart';
import 'package:web_test2/common/data_table/custom_sfDataGrid.dart';

DataGridController dataGridController = DataGridController();

class MembersTable extends ConsumerStatefulWidget {
  final bool showMore;
  final List<Member> members;
  final double? height;

  const MembersTable({
    this.height = 400,
    required this.members,
    required this.showMore,
    super.key,
  });

  @override
  ConsumerState<MembersTable> createState() => MembersTableState();
}

class MembersTableState extends ConsumerState<MembersTable> {
  late MembersDataSource membersDataSource;

  // late List<Member> membersFuture;
  late Map<String, double> columnWidths = {
    'docId': double.nan,
    'status': double.nan,
    'id': double.nan,
    'displayName': double.nan,
    'birthDay': double.nan,
    'gender': double.nan,
    'phoneNumber': double.nan,
    'address': double.nan,
    'signUpPath': double.nan,
    'referralID': double.nan,
    'referralName': double.nan,
    'accountLinkID': double.nan,
    'memo': double.nan,
    'contractStatus': double.nan,
    'referralCount': double.nan,
    'firstDate': double.nan,
    'expiryDate': double.nan,
    'totalFee': double.nan,
    'totalAttendanceDays': double.nan,
    'openVOC': double.nan,
    'closeVOC': double.nan,
    'unresolvedVOC': double.nan,
    'updatedAt': double.nan,
    'createdAt': double.nan,
    'updatedBy': double.nan,
    'checkbox': double.nan,
    // 'actions': 100,
  };

  @override
  void initState() {
    super.initState();
    {
      setState(() {
        membersDataSource = MembersDataSource(membersData: widget.members);
      });
    }
  }

  @override
  void didUpdateWidget(MembersTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if members list has been updated
    if (widget.members != oldWidget.members) {
      setState(() {
        membersDataSource = MembersDataSource(membersData: widget.members);
      });
    }
  }

  // Future<void> addMember(Member member) async {
  //   List<Member> currentMembers = membersDataSource._membersData;
  //   currentMembers.add(member);
  //   setState(() {
  //     membersDataSource = MembersDataSource(membersData: currentMembers);
  //   });
  // }

  int _rowsPerPage = 20;
  final double _dataPagerHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final visible = screenWidth <= 640
        ? false
        : widget.showMore
            ? true
            : false;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.white,
            height: widget.height! - _dataPagerHeight,
            // width: containerWidth,
            child: SelectionArea(
              child: CustomSfDataGrid(
                onSelectionChanged: (List<DataGridRow> addedRows,
                    List<DataGridRow> removedRows) {
                  print(widget.members[dataGridController.selectedIndex].id);
                  ref.read(selectedRowProvider.notifier).setSelectedRow(
                      widget.members[dataGridController.selectedIndex].id);
                },
                // onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex,
                //     RowColumnIndex previousRowColumnIndex) {
                //   print(widget.members[dataGridController.selectedIndex].id);
                //   ref.read(selectedRowProvider.notifier).setSelectedRow(widget.members[dataGridController.selectedIndex].id);
                // },
                allowEditing: true,
                rowsPerPage: _rowsPerPage,
                onColumnResizeStart: (ColumnResizeStartDetails details) {
                  if (details.columnIndex == 0) {
                    return false;
                  }
                  return true;
                },
                onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                  setState(() {
                    columnWidths[details.column.columnName] = details.width;
                  });
                  return true;
                },
                dataGridSource: membersDataSource,
                dataGridController: dataGridController,
                columnWidths: columnWidths,
                columns: <GridColumn>[
                  CustomGridColumn(
                    width: columnWidths['docId']!,
                    label: 'id',
                    columnName: 'docId',
                    visible: false,
                  ),
                  CustomGridColumn(
                    width: columnWidths['status']!,
                    label: 'status',
                    columnName: 'status',
                    visible: false,
                  ),
                  CustomGridColumn(
                    width: columnWidths['displayName']!,
                    label: '이름',
                    columnName: 'displayName',
                  ),
                  CustomGridColumn(
                    width: columnWidths['gender']!,
                    label: '성별',
                    columnName: 'gender',
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['birthDay']!,
                    label: '생년월일',
                    columnName: 'birthDay',
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['phoneNumber']!,
                    label: '전화번호',
                    columnName: 'phoneNumber',
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['address']!,
                    label: '행정동',
                    columnName: 'address',
                    visible: screenWidth <= 640 ? false : true,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['signUpPath']!,
                    label: '등록경위',
                    columnName: 'signUpPath',
                    visible: screenWidth <= 640 ? false : true,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['referralID']!,
                    label: '추천인ID',
                    columnName: 'referralID',
                    visible: false,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['referralName']!,
                    label: '추천인',
                    columnName: 'referralName',
                    visible: screenWidth <= 640 ? false : true,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['accountLinkID']!,
                    label: '계정연결',
                    columnName: 'accountLinkID',
                    visible: screenWidth <= 640 ? false : true,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['memo']!,
                    label: '메모',
                    columnName: 'memo',
                    visible: screenWidth <= 640 ? false : true,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['id']!,
                    label: '아이디',
                    columnName: 'id',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['contractStatus']!,
                    label: '계약상태',
                    columnName: 'contractStatus',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['referralCount']!,
                    label: '추천인수',
                    columnName: 'referralCount',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['firstDate']!,
                    label: '첫수강일',
                    columnName: 'firstDate',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['expiryDate']!,
                    label: '종료예정',
                    columnName: 'expiryDate',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['totalFee']!,
                    label: '총납부금',
                    columnName: 'totalFee',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['totalAttendanceDays']!,
                    label: '총출석일',
                    columnName: 'totalAttendanceDays',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['openVOC']!,
                    label: '진행',
                    columnName: 'openVOC',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['closeVOC']!,
                    label: '완료',
                    columnName: 'closeVOC',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    allowEditing: true,
                    width: columnWidths['unresolvedVOC']!,
                    label: '미결',
                    columnName: 'unresolvedVOC',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    width: columnWidths['createdAt']!,
                    label: '입력 날짜',
                    columnName: 'createdAt',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    width: columnWidths['updatedAt']!,
                    label: '수정 날짜',
                    columnName: 'updatedAt',
                    visible: visible,
                  ),
                  CustomGridColumn(
                    width: columnWidths['updatedBy']!,
                    label: '최종 수정',
                    columnName: 'updatedBy',
                    visible: visible,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            width: 1000,
            height: _dataPagerHeight,
            child: SfDataPagerTheme(
              data: SfDataPagerThemeData(
                selectedItemColor: PRIMARY_COLOR,
                itemTextStyle: TextStyle(
                  fontFamily: 'SebangGothic',
                ),
              ),
              child: SfDataPager(
                navigationItemWidth: 40,
                navigationItemHeight: 40,
                itemWidth: 40,
                itemHeight: 40,

                delegate: membersDataSource,
                availableRowsPerPage: const [20, 50, 100],
                onRowsPerPageChanged: (int? rowsPerPage) {
                  setState(() {
                    _rowsPerPage = rowsPerPage!;
                  });
                },
                pageCount:
                    ((widget.members.length / _rowsPerPage).ceil().toDouble()),
                // itemWidth: 50,
              ),
            ),
          ),
          // if (screenHeight > 750)

          // ),
          // TextButton(
          //   child: Text('Get Selection Information'),
          //   onPressed: () {
          //     print(snapshot
          //         .data?[dataGridController.selectedIndex].email);
          //     // dataGridController.beginEdit(RowColumnIndex(3, 3));
          //   },
          // ),
        ],
      ),
    );
  }
}

class MembersDataSource extends DataGridSource {
  MembersDataSource({required List<Member> membersData}) {
    // _paginatedOrders = _orders.getRange(0, 19).toList(growable: false);
    _membersData = membersData;
    // _paginatedRows = employeeData;
    buildPaginatedDataGridRows();
  }

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  List<DataGridRow> _membersDataGridRows = [];
  List<Member> _membersData = [];

  @override
  List<DataGridRow> get rows => _membersDataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        // color: Colors.white,
        cells: row.getCells().map<Widget>((e) {
      final int index = effectiveRows.indexOf(row);
      late String cellValue;
      if (e.value.runtimeType == DateTime) {
        cellValue = DateFormat('yyyy/MM/dd HH:mm').format(e.value);
      } else {
        cellValue = e.value.toString();
      }
      return Container(
        color: (dataGridController.selectedRows.contains(row))
            ? TABLE_SELECTION_COLOR
            : (index % 2 != 0)
                ? TABLE_COLOR
                : Colors.transparent,
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(8.0),
        child: e.columnName == 'actions'
            ? dataGridController.selectedIndex == index
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ],
                  )
                : null
            : Text(
                cellValue,
                // enableInteractiveSelection: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'SebangGothic',
                    fontSize: 11,
                    color: dataGridController.selectedRows.contains(row)
                        ? Colors.white
                        : Colors.black87),
              ),
      );
    }).toList());
  }

  void buildPaginatedDataGridRows() {
    _membersDataGridRows = _membersData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              // DataGridCell<IconButton>(columnName: 'actions', value: null),
              DataGridCell<String>(columnName: 'docId', value: e.docId),
              DataGridCell<String>(columnName: 'status', value: e.status),
              DataGridCell<String>(
                  columnName: 'displayName', value: e.displayName),
              DataGridCell<String>(columnName: 'gender', value: e.gender),
              DataGridCell<String>(columnName: 'birthDay', value: e.birthDay),
              DataGridCell<String>(
                  columnName: 'phoneNumber', value: e.phoneNumber),
              DataGridCell<String>(columnName: 'address', value: e.address),
              DataGridCell<String>(
                  columnName: 'signUpPath', value: e.signUpPath),
              DataGridCell<int>(columnName: 'referralID', value: e.referralID),
              DataGridCell<String>(
                  columnName: 'referralName', value: e.referralName),
              DataGridCell<String>(
                  columnName: 'accountLinkID', value: e.accountLinkID),
              DataGridCell<String>(columnName: 'memo', value: e.memo),
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(
                  columnName: 'contractStatus', value: e.contractStatus),
              DataGridCell<int>(
                  columnName: 'referralCount', value: e.referralCount),
              DataGridCell<String?>(
                  columnName: 'firstDate', value: e.firstDate),
              DataGridCell<String?>(
                  columnName: 'expiryDate', value: e.expiryDate),
              DataGridCell<int>(columnName: 'totalFee', value: e.totalFee),
              DataGridCell<int>(
                  columnName: 'totalAttendanceDays',
                  value: e.totalAttendanceDays),
              DataGridCell<int>(columnName: 'openVOC', value: e.openVOC),
              DataGridCell<int>(columnName: 'closeVOC', value: e.closeVOC),
              DataGridCell<int>(
                  columnName: 'unresolvedVOC', value: e.unresolvedVOC),
              DataGridCell<DateTime>(
                  columnName: 'createdAt', value: e.createdAt),
              DataGridCell<DateTime>(
                  columnName: 'updatedAt', value: e.updatedAt),
              DataGridCell(columnName: 'updatedBy', value: e.updatedBy)
            ]))
        .toList();
  }
}
