import { SSMClient, GetParametersCommand } from "@aws-sdk/client-ssm";
import { child } from "./logger.js";

const log = child("config");

// Initialize SSM client with region from env or default to us-east-1
const region = process.env.AWS_REGION || "us-east-1";
const ssm = new SSMClient({ region });

const PARAMS = [
  "/dev/database/endpoint",
  "/dev/database/port",
  "/dev/database/dbname",
  "/dev/database/username",
  "/dev/database/region"
];

// loadConfig supports a local/dev fallback when `USE_LOCAL_CONFIG` is set
export async function loadConfig() {
  const useLocal =
    process.env.USE_LOCAL_CONFIG === "1" ||
    process.env.USE_LOCAL_CONFIG === "true";

  if (useLocal) {
    log.info("Using local config fallback");
    const conf = {
      endpoint: process.env.LOCAL_DB_HOST || "127.0.0.1",
      port: Number(process.env.LOCAL_DB_PORT || 3306),
      dbname: process.env.LOCAL_DB_NAME || "test",
      username: process.env.LOCAL_DB_USER || "root",
      region: process.env.AWS_REGION || process.env.LOCAL_AWS_REGION || "us-east-1"
    };
    log.debug("Local config:", conf);
    return conf;
  }

  log.info("Requesting parameters from SSM: %s", PARAMS.join(", "));
  const res = await ssm.send(
    new GetParametersCommand({
      Names: PARAMS,
      WithDecryption: false
    })
  );

  const map = {};
  if (res.Parameters) {
    for (const p of res.Parameters) {
      map[p.Name] = p.Value;
    }
    log.info("Fetched %d parameters from SSM", res.Parameters.length);
    log.debug("Parameter keys: %s", Object.keys(map).join(", "));
  } else {
    log.warn("No parameters returned from SSM");
  }

  const conf = {
    endpoint: map["/dev/database/endpoint"],
    port: Number(map["/dev/database/port"]),
    dbname: map["/dev/database/dbname"],
    username: map["/dev/database/username"],
    region: map["/dev/database/region"]
  };

  log.debug("Loaded config:", { endpoint: conf.endpoint, port: conf.port, dbname: conf.dbname, username: conf.username });
  return conf;
}