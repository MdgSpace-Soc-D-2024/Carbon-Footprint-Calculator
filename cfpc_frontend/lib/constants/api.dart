const String api = 'http://127.0.0.1:8000';



const Map<String, String> headers = {
  'Content-Type': 'application/json',
};

const loginURL = '$api/login/login/';

const registerURL = '$api/login/register/';

const homeURL = '$api/home/';

const insertFootprintsURL = '$api/footprintdata/insertdata/';
const viewFootprintsURL = '$api/footprintdata/viewdata/';
const shareFootprintsURL = '$api/footprintdata/sharedata/';
const viewSharedFootprintsURL = '$api/footprintdata/viewshareddata/';