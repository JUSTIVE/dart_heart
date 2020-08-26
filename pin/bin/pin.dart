import 'dart:io';
import 'dart:convert';
import 'package:cli_util/cli_util.dart';
import 'package:args/args.dart';


const recursive = 'recursive';
ArgResults argResults;

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addFlag(recursive,negatable:false, abbr:'r');
  argResults = parser.parse(arguments);
  final fileName = argResults.rest;

  pin(fileName,argResults[recursive] as bool);
}

Future pin(List<String> filename,bool recursive) async{
  if(filename.isEmpty || filename.length>1){
    await stdin.pipe(stdout);
    return;
  }
  Directory.current
    .list(recursive:true,followLinks: true)
    .listen((FileSystemEntity entity) => {
      print(entity.path)
    });
  

}