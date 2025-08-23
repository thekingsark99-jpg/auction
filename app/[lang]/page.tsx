type PageProps = {
  params: { lang: string }
}

export default function Page({ params }: PageProps) {
  return (
    <main>
      <h1>Language: {params.lang}</h1>
    </main>
  );
}
export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' }
  ];
}
