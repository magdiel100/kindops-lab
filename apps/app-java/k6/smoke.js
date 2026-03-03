import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 2,
  iterations: 10,
  thresholds: {
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<800"],
  },
};

export default function () {
  const response = http.get(`${__ENV.SMOKE_BASE_URL || "http://localhost:8080"}/actuator/health`);
  check(response, {
    "status is 200": (r) => r.status === 200,
    "body has UP": (r) => r.body.includes("UP"),
  });
  sleep(1);
}
