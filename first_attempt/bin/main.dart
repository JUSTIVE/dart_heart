import 'dart:convert';
import 'dart:io';
import 'package:cli_util/cli_util.dart';
import 'package:args/args.dart';
import 'package:first_attempt/first_attempt.dart' as first_attempt;

const lineNumber = 'line-number';

ArgResults argResults;

main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addFlag(lineNumber, negatable:false, abbr: 'n');
  argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, argResults[lineNumber] as bool);
}

Future dcat(List<String> paths, bool showLineNumbers) async {
  if (paths.isEmpty){
    await stdin.pipe(stdout);
  }else{
    for (var path in paths){
      var lineNumber = 1;
      final lines = utf8.decoder
        .bind(File(path).openRead())
        .transform(const LineSplitter());
      
      try{
        await for (var line in lines){
          if(showLineNumbers)
            stdout.write('${lineNumber++}\t');
          stdout.writeln(line);
        }
      }catch(_){
        await _handleError(path);
      }
    }
  }
}

Future _handleError(String path) async {
  if(await FileSystemEntity.isDirectory(path)){
    stderr.writeln('error : $path is a directory');
  }else{
    exitCode = 2;
  }
}