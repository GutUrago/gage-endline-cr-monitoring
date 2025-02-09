exports.handler = async () => {
  const GITHUB_REPO = "GutUrago/gage-endline-cr-monitoring";
  const GITHUB_TOKEN = process.env.GH_PAT;

  const response = await fetch(`https://api.github.com/repos/${GITHUB_REPO}/dispatches`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${GITHUB_TOKEN}`,
      "Accept": "application/vnd.github.v3+json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ event_type: "trigger-run" })
  });

  if (response.ok) {
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "GitHub Action triggered successfully!" })
    };
  } else {
    return {
      statusCode: response.status,
      body: JSON.stringify({ message: "Failed to trigger GitHub Action" })
    };
  }
};
