unit fstrings;
{
  Resource strings form of AWGG

  Copyright (C) 2020 Reinier Romero Mir
  nenirey@gmail.com

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}
{$mode objfpc}{$H+}

Interface

resourcestring

startqueuesystray='Start queue';
stopqueuesystray='Stop queue';
downloadpathname='Downloads';
categorycompressed='Compressed';
categoryprograms='Programs';
categoryimages='Images';
categorydocuments='Documents';
categoryvideos='Videos';
categorymusic='Music';
categoryothers='Others';
categoryfilter='Categories';
categorytorrents='Torrents';
abouttext='This program is free software under GNU GPL 2 license.'+
lineending+lineending+'Created By Reinier Romero Mir'+
lineending+'Email: nenirey@gmail.com'+
lineending+'Copyright (c) 2014-2020'+
lineending+lineending+'The project uses the following third party resources:'+
lineending+'- Silk icons set 1.3 by Mark James (http://www.famfamfam.com/lab/icons/silk/'+
lineending+'- Tango Icon Library (http://tango.freedesktop.org/Tango_Icon_Library)'+
lineending+'- aria2 (http://aria2.sourceforge.net)'+
lineending+'- Wget (http://www.gnu.org/software/wget/)'+
lineending+'- cURL (http://curl.haxx.se)'+
lineending+'- Axel (http://axel.alioth.debian.org)'+
lineending+'- youtube-dl (http://yt-dl.org)'+
lineending+'- Download with Wget (http://add0n.com/download-with.html?from=wget)'+
lineending+lineending+'French translation: Tony O Gallos @ CodeTyphon Community'+
lineending+'German translation: Mag Fu (mag.fu@yandex.com)'+
lineending+'Tukish translation: BigLorD @ Github.com'+
lineending+'Portuguese translation: havokdan@yahoo.com.br'+
lineending+'Chinese, Italian, Russian translation: Ronaldo Rodrigues Oliveira (morcberry@gmail.com)';
wgetdefarg1='[-c] Continue downloads.';
wgetdefarg2='[-nH] No create host dir.';
wgetdefarg3='[-nd] No create out dir.';
wgetdefarg4='[--no-check-certificate] No check SSL.';
aria2defarg1='[-c] Continue downloads';
aria2defarg2='[--file-allocation=none] No allocate space.';
curldefarg1='[-C -] Continue downloads.';
firefoxintegration='Do you want to enable firefox integration?';
transfromlabel='From: %S';
transdestinationlabel='To: %S';
fileexistsreplacetext='The file "%S" already exists, do you want to replace it?';
fileoperationcopy='Coping file(s)...';
fileoperationmove='Moving file(s)...';
msgerrorconfigsave='Error saving config file: ';
msgerrorconfigload='Error loading config file: ';
statusinprogres='In progress';
msgnoexistfolder='The folder not exists: ';
msgmustselectdownload='You must select a download.';
msgerrordownlistsave='Error saving the download list';
dlgdeletedownandfile='Do you want to delete the selected download(s) and file(s) in disk?';
dlgdeletedown='Do you want to delete the selected download(s)?';
dlgconfirm='Confirm';
statuscomplete='Complete';
popuptitlecomplete='Download complete';
statusstoped='Stopped';
statuscanceled='Canceled';
popuptitlestoped= 'Download stopped:';
msgcloseinprogressdownload= 'Downloads exist in progress, do you want to close anyway?';
titlepropertiesdown= 'Download properties';
btnpropertiesok= 'Ok';
titlenewdown= 'New download';
btnnewdownstartnow= 'Start now';
msgnoexisthistorylog= 'The history log for the download does not exist!';
dlgrestartalldownloads= 'Do you want to restart all downloads?';
dlgdeletealldownloads= 'Do you want to delete all downloads?';
msgfilenoexist= 'The file not exists.';
dlgrestartalldownloadslatter= 'Do you want to restart all downloads later?';
statuspaused= 'Paused';
dlgrestartselecteddownloadletter= 'Do you want to restart the selected download later?';
dlgclearhistorylogfile= 'Do you want to clear the history log file?';
dlgrestartselecteddownload= 'Do you want to restart the selected download?';
sunday= 'Sunday';
monday= 'Monday';
tuesday= 'Tuesday';
wednesday= 'Wednesday';
thursday= 'Thursday';
friday= 'Friday';
saturday= 'Saturday';
msgmustselectdownloadengine= 'You must select a download engine!!''';
msgmustselectweekday= 'You must select one week day!!';
runwiththesystem= 'Run with the system.';
automaticstartscheduler= 'Automatic start the scheduler.';
startinthesystray= 'Start in the systray.';
statuserror= 'Error';
queuemainname= 'Main';
dlgdeletequeue= 'Do you want to delete the selected queue?';
msgclearcomplete= 'Do you want to clear all completed downloads?';
queuestreename= 'Queues';
filtresname= 'Filters';
alldowntreename='All downloads';
queuename= 'Queue';
proxynot= 'No proxy';
proxysystem= 'System proxy';
proxymanual='Manual';
msgchromeexecutable='Please select the Chrome or (Chromium-Based) browser executable file';
msgfirefoxexecutable='Please select the Firefox or (Firefox-Based) browser executable file';
msgoperaexecutable='Please select the Opera launcher executable file';
fileexistsreplace= 'The file exist, do you want replace it?';
rootdownloadpathchange= 'The root of the downloads folder has changed, would like to recreate the routes by categories in the new root?';
newfiletyperememberpath= 'Do you want to remember the path for this file type?';
msgerrorinforme='Oh!! this is rare, an error occured, please report this to email nenirey@gmail.com with the attach file:'+LineEnding+'%s'+LineEnding+'Error description:'+LineEnding+'%s'+LineEnding+'Press [Ok] to report, [Cancel] to close the program and [Ignore] to continue';
videoformatloading='Loading available formats, please wait';
videonameloading='Loading video name, please wait';
videoselectformat='Select video format:';
videoname='Name:';
errorloadingformat='Error loading video formats, please press reload button';
errorloadingname='Error loading video name, please press reload button';
commonvideodescription='The best quality video in %s format (if exists)';
commonaudiodescription='The best quality audio in %s format (if exists)';
msgcopyoperationerror='Error to copy file, details:'+lineending+'%s';
msgmoveoperationerror='Error to move file, details:'+lineending+'$s';
statusstarting='Starting...';
statusstopping='Stopping...';
filterforcenames='Force downloads names';
filternoforcenames='No force downloads names';
nochangefield='[Keep]';
portablemode='Portable';
msginternetconnection='Internet connection';
msgnointernetconnection='No internet connection';
msgupdatechecking='Checking...';
msguptodate='Up to date!';

Implementation
end.

