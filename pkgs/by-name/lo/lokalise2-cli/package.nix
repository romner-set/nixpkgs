{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-CFZB1nELQOBNOuISTjes4vhXMr8Pjq4Rj83nq/FfpMY=";
  };

  vendorHash = "sha256-sM4v1EWxXPUFKFWcl9EBc8ZTmm2STOVoeGH9Zv+KEng=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = with lib; {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timstott ];
    mainProgram = "lokalise2";
  };
}
