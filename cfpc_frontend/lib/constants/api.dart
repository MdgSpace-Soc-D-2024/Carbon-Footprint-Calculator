const String api = 'http://127.0.0.1:8000';

const registerURL = '$api/login/register/';
const Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

const loginURL = '$api/login/login/';

const insertFootprintsURL = '$api/footprintdata/insertdata/';
const viewFootprintsURL = '$api/footprintdata/viewdata/';
const shareFootprintsURL = '$api/footprintdata/sharedata/';
const viewSharedFootprintsURL = '$api/footprintdata/viewshareddata/';