// app/[lang]/page.tsx

interface PageProps {
  params: Promise<{ lang: string }>;
}

export default async function Page({ params }: PageProps) {
  const { lang } = await params;

  return (
    <main>
      <h1>Language: {lang}</h1>
    </main>
  );
}

export async function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' }
  ];
}
