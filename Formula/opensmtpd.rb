class Opensmtpd < Formula
  desc "OpenSMTPD is a FREE implementation of the server-side SMTP protocol."
  homepage "https://www.opensmtpd.org/"
  url "https://www.opensmtpd.org/archives/opensmtpd-6.0.3p1.tar.gz"
  sha256 "291881862888655565e8bbe3cfb743310f5dc0edb6fd28a889a9a547ad767a81"
  version "6.0.3p1"
  #head "https://github.com/opensmtpd/opensmtpd.git", :shallow => true, :branch => "portable"
  head "https://github.com/twinshadow/opensmtpd.git", :shallow => true, :branch => "portable"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "byacc" => :build
  depends_on "libtool" => :build
  depends_on "libasr"
  depends_on "libevent"
  depends_on "openssl"

  # XXX Make it so this can replace Postfix as the system mailer
  #option "system-mailer", "Install this to replace the system mailer (requires Administrator privileges)"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "YACC=byacc", "--disable-silent-rules",
                          "--with-user-smtpd=#{ENV["USER"]}",
                          "--with-user-queue=#{ENV["USER"]}",
                          "--with-group-queue=mail",
                          "--with-path-queue=#{HOMEBREW_PREFIX}/var/spool/smtpd",
                          "--with-path-empty=#{HOMEBREW_PREFIX}/empty",
                          "--with-path-mbox=#{HOMEBREW_PREFIX}/var/spool/mail",
                          "--with-path-socket=#{HOMEBREW_PREFIX}/var/run",
                          "--with-path-pidfile=#{HOMEBREW_PREFIX}/var/run",
                          "--with-path-CAfile=#{HOMEBREW_PREFIX}/etc/openssl/cert.pem",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test opensmtpd-6.0.3p`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
