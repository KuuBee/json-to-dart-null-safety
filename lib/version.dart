import 'dart:developer';

import 'package:equatable/equatable.dart';

VersionData? versionPattern(String str) {
  const pattern = r''
      // 主版本号
      r'(?<major>\d+)\.'
      // 子版本号
      r'(?<minor>\d+)?\.?'
      // 修正号
      r'(?<revision>\d+)?'
      // 第三个点后的版本号
      r'(?:\.?(?<dotBuildNumber>\d+))?'
      // 处理这种形式的版本号 6.5.40-Release.9059101
      r'(?:.*?release\.(?<releaseBuildNumber>\d+))?'
      // 括号版本号/编译版本号
      r'(?<other>.*?(?:\((?<bracketsVersion>\d+)\))|(?<buildNumber>\.\d+))?';
  final regExp = RegExp(
    pattern,
    caseSensitive: true,
  );
  final regExpMatch = regExp.firstMatch(str);
  if (regExpMatch != null) {
    final major = regExpMatch.namedGroup('major');
    final minor = regExpMatch.namedGroup('minor');
    final revision = regExpMatch.namedGroup('revision');
    final dotBuildNumber = regExpMatch.namedGroup('dotBuildNumber');
    final releaseBuildNumber = regExpMatch.namedGroup('releaseBuildNumber');
    final bracketsVersion = regExpMatch.namedGroup('bracketsVersion');
    final buildNumber = regExpMatch.namedGroup('buildNumber');
    // log('major:$major,num:${int.tryParse(major ?? '')}');
    // log('minor:$minor,num:${int.tryParse(minor ?? '')}');
    // log('revision:$revision,num:${int.tryParse(revision ?? '')}');
    // log('dotBuildNumber:$dotBuildNumber,num:${int.tryParse(dotBuildNumber ?? '')}');
    // log('releaseBuildNumber:$releaseBuildNumber,num:${int.tryParse(releaseBuildNumber ?? '')}');
    // log('bracketsVersion:$bracketsVersion,num:${int.tryParse(bracketsVersion ?? '')}');
    // log('buildNumber:$buildNumber,num:${int.tryParse(buildNumber ?? '')}');
    return VersionData(
      major: int.tryParse(major ?? '') ?? -1,
      minor: int.tryParse(minor ?? '') ?? -1,
      revision: int.tryParse(revision ?? '') ?? -1,
      dotBuildNumber: int.tryParse(dotBuildNumber ?? '') ?? -1,
      releaseBuildNumber: int.tryParse(releaseBuildNumber ?? '') ?? -1,
      bracketsVersion: int.tryParse(bracketsVersion ?? '') ?? -1,
      buildNumber: int.tryParse(buildNumber ?? '') ?? -1,
    );
  }
  return null;
}

class VersionData extends Equatable {
  final int major;
  final int minor;
  final int revision;
  final int dotBuildNumber;
  final int releaseBuildNumber;
  final int bracketsVersion;
  final int buildNumber;

  const VersionData({
    this.major = -1,
    this.minor = -1,
    this.revision = -1,
    this.dotBuildNumber = -1,
    this.releaseBuildNumber = -1,
    this.bracketsVersion = -1,
    this.buildNumber = -1,
  });
  @override
  List<Object> get props => [
        major,
        minor,
        revision,
        dotBuildNumber,
        releaseBuildNumber,
        bracketsVersion,
        buildNumber,
      ];
}
