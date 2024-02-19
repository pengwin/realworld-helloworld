import grpc from 'k6/net/grpc';
import { check } from 'k6';
import exec from 'k6/execution';
export const options = {
  vus: 500,
  iterations: 10000,
  //httpDebug: 'full',
  insecureSkipTLSVerify: true,
};
const client = new grpc.Client();
client.load(['definitions'], '../../src/HelloProtoWorld/hello.proto');


export default function () {
  // connect once to reuse connection
  if (exec.vu.iterationInScenario == 0) {
    client.connect('hello.local:443', {});
  }

  const response = client.invoke('HelloService/SayHello', {});

  check(response, {
    'status is OK': (r) => r && r.status === grpc.StatusOK,
  });
}