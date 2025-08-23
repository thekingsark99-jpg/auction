export default function Page(props: any) {
  console.log("Page props:", props);
  return (
    <main>
      <h1>Language: {props?.params?.lang}</h1>
    </main>
  );
}
