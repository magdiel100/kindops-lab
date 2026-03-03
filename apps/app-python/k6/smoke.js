import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 2,
  iterations: 10,
  thresholds: {
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<500"],
  },
};

export default function () {
  const response = http.get(`${__ENV.SMOKE_BASE_URL || "http://localhost:8000"}/health`);
  check(response, {
    "status is 200": (r) => r.status === 200,
    "body has ok": (r) => r.body.includes("ok"),
  });
  sleep(1);
}
